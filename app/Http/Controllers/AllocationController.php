<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Carbon\Carbon;
use App\Models\Allocation;
use Inertia\Inertia;
use App\Models\Province;
use App\Models\CityMuni;
use App\Models\Program;
use App\Models\ClientLog; // Import ClientLog model
use Illuminate\Support\Facades\Redirect;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\ValidationException;

class AllocationController extends Controller
{
    public function index()
    {
        $allocations = Allocation::with(['province', 'citymuni', 'program'])->get();

        \Log::info('Allocations Data:', $allocations->toArray());

        return response()->json([
            'allocations' => $allocations
        ]);
    }
    public function create()
    {
        $provinces = Province::all();
        $programs = Program::all();
    
        return Inertia::render('Client/AllocationForm', [
            'provinces' => $provinces,
           'programs' => $programs->map(function ($program) {
                return [
                    'id' => $program->id,
                    'name' => $program->name,
                    'status' => $program->status,
                ];
            }),
            'cities' => [], 
            
        ]);
    }

    public function store(Request $request)
{
    \Log::info('Request data:', $request->all());

    // Fetch the program by name and check if it's restricted
    $program = Program::where('name', $request->program)->first();
    if (!$program) {
        throw ValidationException::withMessages(['program' => 'Invalid program selected.']);
    }

    if ($program->status == 1) {
        throw ValidationException::withMessages(['program' => 'You cannot submit an allocation for a restricted program.']);
    }

    // Fetch PSGC codes for province and city_municipality
    $province = Province::where('col_province', $request->province)->first();
    $city_municipality = CityMuni::where('col_citymuni', $request->city_municipality)->first();

    if (!$province || !$city_municipality) {
        throw ValidationException::withMessages(['location' => 'Invalid province or city/municipality selected.']);
    }

    // Check if allocation already exists for the year
    $currentYear = Carbon::now()->year;
    $existingAllocation = Allocation::where('province', $province->psgc)
        ->where('city_municipality', $city_municipality->psgc)
        ->where('program', $program->id)
        ->whereYear('created_at', $currentYear)
        ->first();

    if ($existingAllocation) {
        throw ValidationException::withMessages(['error' => 'An allocation for this province, city/municipality, and program has already been submitted this year.']);
    }

    // Validate and create allocation
    $validatedData = $request->validate([
        'province' => 'required|string|max:255',
        'city_municipality' => 'required|string|max:255',
        'program' => 'required|string|max:100',
        'target' => 'required|integer|min:0',
        'fund_allocation' => 'required|integer|min:0',
    ]);

    $validatedData['province'] = $province->psgc;
    $validatedData['city_municipality'] = $city_municipality->psgc;
    $validatedData['program'] = $program->id;

    $allocation = Allocation::create($validatedData);

     // Create log for the new allocation
     ClientLog::create([
        'user_id' => Auth::id(),
        'action' => 'added',
        'type' => 'allocation',
        'record_id' => $allocation->id,
        'program' => $allocation->program,
    ]);

    \Log::info('Log entry created for new allocation.', ['allocation_id' => $allocation->id]);

    return redirect()->route('client-reports')->with('success', 'Allocation created successfully');
}
    
public function update(Request $request, Allocation $allocation)
{
    \Log::info('Update Request received:', $request->all());

    // Fetch the program by name and check if it's restricted
    $program = Program::where('name', $request->program)->first();

    if (!$program) {
        \Log::error('Program not found:', ['program' => $request->program]);
        return back()->withErrors(['program' => 'Invalid program selected.'])->withInput();
    }

    if ($program->status == 1) {
        \Log::error('Program is restricted:', ['program' => $program->name]);
        return back()->withErrors(['program' => 'You cannot update an allocation for a restricted program.'])->withInput();
    }

    // Fetch the PSGC codes for province and city_municipality based on names
    $province = Province::where('col_province', $request->province)->first();
    $city_municipality = CityMuni::where('col_citymuni', $request->city_municipality)->first();

    if (!$province || !$city_municipality) {
        \Log::error('Invalid location selection:', [
            'province' => $request->province,
            'city_municipality' => $request->city_municipality
        ]);
        return back()->withErrors(['location' => 'Invalid province or city/municipality selected.'])->withInput();
    }

     // Check if allocation already exists for the year, excluding the current allocation being edited
     $currentYear = Carbon::now()->year;
     $existingAllocation = Allocation::where('province', $province->psgc)
         ->where('city_municipality', $city_municipality->psgc)
         ->where('program', $program->id)
         ->whereYear('created_at', $currentYear)
         ->where('id', '!=', $allocation->id) // Exclude the current allocation
         ->first();
 
     if ($existingAllocation) {
         return back()->withErrors(['error' => 'An allocation for this province, city/municipality, and program has already been submitted this year.'])->withInput();
     }

    // Validate the request data
    $validatedData = $request->validate([
        'province' => 'required|string|max:255',
        'city_municipality' => 'required|string|max:255',
        'program' => 'required|string|max:100',
        'target' => 'required|integer|min:0',
        'fund_allocation' => 'required|numeric|min:0',
    ]);

    // Convert fund_allocation to decimal
    $validatedData['fund_allocation'] = (float) $validatedData['fund_allocation'];

    // Override the province and city names with the PSGC codes
    $validatedData['province'] = $province->psgc;
    $validatedData['city_municipality'] = $city_municipality->psgc;
    $validatedData['program'] = $program->id;

    // Update the allocation with the validated data
    try {
        $allocation->update($validatedData);
        \Log::info('Allocation updated successfully for ID:', ['id' => $allocation->id]);  // Corrected log
    } catch (\Exception $e) {
        \Log::error('Error updating allocation:', ['error' => $e->getMessage()]);
        return back()->withErrors(['error' => 'Failed to update allocation.'])->withInput();
    }

    // Log the action of updating an allocation
    try {
        ClientLog::create([
            'user_id' => auth()->id(),
            'action' => 'edited',
            'type' => 'allocation',
            'record_id' => $allocation->id,
            'program' => $allocation->program, 
        ]);
        \Log::info('Client log entry created for allocation update:', ['id' => $allocation->id]);  // Corrected log
    } catch (\Exception $e) {
        \Log::error('Error creating client log:', ['error' => $e->getMessage()]);
        return back()->withErrors(['error' => 'Failed to log the update action.']);
    }

    // Redirect to client reports page with a success message
    return redirect()->route('client-reports')->with('success', 'Allocation updated successfully.');
}
 
public function getAllocations(Request $request)
{
    $user = Auth::user();
    $query = Allocation::with(['province', 'citymuni', 'program'])->where('program', $user->program);

    // Filter by date if provided
    if ($request->has('date')) {
        $query->whereDate('created_at', $request->date);
    }

    // Filter by province if provided
    if ($request->has('province')) {
        $provincePsgc = Province::where('psgc', $request->province)->first();

        if ($provincePsgc) {
            $query->where('province', $provincePsgc->psgc);
        } else {
            return response()->json(['error' => 'Invalid province selected.'], 400);
        }
    }

    // Fetch the filtered allocations
    $allocations = $query->get();

    return response()->json([
        'allocations' => $allocations,
    ]);
}

    public function getAllocationProvinces(Request $request)
{
    $userProgram = Auth::user()->program;

    // Fetch distinct provinces where allocations exist for the user's program
    $allocations = Allocation::where('program', $userProgram)
        ->with('province')
        ->get();

    // Filter out any allocations without a valid province relationship
    $provinces = $allocations->filter(function ($allocation) {
        return $allocation->province !== null;
    })->pluck('province')
      ->unique('psgc')
      ->values();

    \Log::info('Fetched Allocation Provinces:', $provinces->toArray());

    return response()->json(['provinces' => $provinces]);
}

public function checkExistingAllocation(Request $request)
{
    // Log incoming request for debugging
    \Log::info('Check existing allocation request:', $request->all());

    // Fetch the province PSGC code
    $province = Province::where('col_province', $request->province)->first();
    $city_municipality = CityMuni::where('col_citymuni', $request->city_municipality)->first();
    $program = Program::where('name', $request->program)->first();

    // Check if required fields are valid
    if (!$province || !$city_municipality || !$program) {
        return response()->json(['exists' => false, 'error' => 'Invalid province, city/municipality, or program selected.'], 400);
    }

    // Check if an allocation already exists for this year
    $currentYear = Carbon::now()->year;
    $existingAllocation = Allocation::where('province', $province->psgc)
        ->where('city_municipality', $city_municipality->psgc)
        ->where('program', $program->id)
        ->whereYear('created_at', $currentYear)
        ->exists();

    if ($existingAllocation) {
        return response()->json(['exists' => true, 'error' => 'An allocation for this province, city/municipality, and program has already been submitted this year.']);
    }

    return response()->json(['exists' => false]);
}
}