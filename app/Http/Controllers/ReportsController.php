<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Carbon\Carbon;
use Inertia\Inertia;
use App\Models\Utilization;
use App\Models\Allocation;
use App\Models\Province;
use App\Models\CityMuni;
use App\Models\Program;
use App\Models\ClientLog; // Import ClientLog model
use Illuminate\Support\Facades\Auth;

class ReportsController extends Controller
{
    public function index()
    {
        // Eager load province, cityMuni, and program relationships
        $utilizations = Utilization::with(['province', 'citymuni', 'program'])->get();

        // Transform the data to include province and city/municipality names
        $utilizations = $utilizations->map(function ($utilization) {
            return [
                'id' => $utilization->id,
                'province' => $utilization->province->col_province ?? 'Unknown Province',  // Get province name
                'city_municipality' => $utilization->cityMuni->col_citymuni ?? 'Unknown City/Municipality',  // Get city/municipality name
                'program' => $utilization->program->name ?? 'Unknown Program',  // Get program name
                'physical' => $utilization->physical,
                'fund_utilized' => $utilization->fund_utilized,
                'created_at' => $utilization->created_at,
                'updated_at' => $utilization->updated_at,
            ];
        });

        return response()->json(['utilizations' => $utilizations]);
    }

    public function create()
    {
        $provinces = Province::all();
        $programs = Program::all();
    
        return Inertia::render('Client/UtilizationForm', [
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
            return back()->withErrors(['program' => 'Invalid program selected.'])->withInput();
        }
    
        if ($program->status == 1) {
            return back()->withErrors(['program' => 'You cannot submit a utilization for a restricted program.'])->withInput();
        }
    
         // Fetch the PSGC codes for province and city_municipality based on names
    $province = Province::where('col_province', $request->province)->first();
    $city_municipality = CityMuni::where('col_citymuni', $request->city_municipality)
        ->where('province_psgc', $province->psgc) // Ensure the city is linked to the correct province
        ->first();

    if (!$province || !$city_municipality) {
        return back()->withErrors(['location' => 'Invalid province or city/municipality selected.'])->withInput();
    }
    
    
        // Log the PSGC codes for debugging purposes
        \Log::info('Province PSGC:', ['psgc' => $province->psgc]);
        \Log::info('City Municipality PSGC:', ['psgc' => $city_municipality->psgc]);

    // Fetch the allocation for the given province, city, and program
    $allocation = Allocation::where('province', $province->psgc)
        ->where('city_municipality', $city_municipality->psgc)
        ->where('program', $program->id)
        ->first();

    if (!$allocation) {
        return back()->withErrors(['allocation' => 'Allocation not found for the selected province, city/municipality, and program.'])->withInput();
    }

    // Calculate the total fund utilized for this province, city, and program
    $totalUtilized = Utilization::where('province', $province->psgc)
        ->where('city_municipality', $city_municipality->psgc)
        ->where('program', $program->id)
        ->sum('fund_utilized');

    $remainingAllocation = $allocation->fund_allocation - $totalUtilized;
    
      // Validate the incoming request
    try {
        $validatedData = $request->validate([
            'province' => 'required|string|max:255',
            'city_municipality' => 'required|string|max:255',
            'program' => 'required|string|max:100',
            'physical' => 'required|integer|min:0',
            'fund_utilized' => 'required|numeric|min:0|max:' . $remainingAllocation,
        ], [
            'fund_utilized.max' => 'The fund utilized cannot exceed the remaining allocated amount of ' . $remainingAllocation,
        ]);
    } catch (ValidationException $e) {
        \Log::error('Validation failed:', ['errors' => $e->errors()]);
        return back()->withErrors($e->errors())->withInput();
    }
    
        // Override the province and city names with the PSGC codes
        $validatedData['province'] = $province->psgc;
        $validatedData['city_municipality'] = $city_municipality->psgc;
        $validatedData['program'] = $program->id; // Replace program name with its ID
    
        // Create a new utilization record using PSGC codes and program ID
        $utilization = Utilization::create($validatedData);
    
        \Log::info('Validated data:', $validatedData);
    
        // Log the action of creating a new utilization
        ClientLog::create([
            'user_id' => auth()->id(),
            'action' => 'added',
            'type' => 'utilization',
            'record_id' => $utilization->id, // The new utilization's ID
            'program' => $utilization->program,  // Store the program ID in the client log
        ]);
    
        // Redirect to client reports page with a success message
        return Inertia::location(route('client-reports'));
    }    
    public function update(Request $request, Utilization $utilization)
    {
        \Log::info('Update Request received for Utilization:', $request->all());
    
        // Fetch the program by name and check if it's restricted
        $program = Program::where('name', $request->program)->first();
    
        if (!$program) {
            \Log::error('Program not found:', ['program' => $request->program]);
            return back()->withErrors(['program' => 'Invalid program selected.'])->withInput();
        }
    
        if ($program->status == 1) {
            \Log::error('Program is restricted:', ['program' => $program->name]);
            return back()->withErrors(['program' => 'You cannot update a utilization for a restricted program.'])->withInput();
        }
    
         // Fetch the PSGC codes for province and city_municipality based on names
    $province = Province::where('col_province', $request->province)->first();
    $city_municipality = CityMuni::where('col_citymuni', $request->city_municipality)
        ->where('province_psgc', $province->psgc) // Ensure the city is linked to the correct province
        ->first();

    if (!$province || !$city_municipality) {
        \Log::error('Invalid location selection:', [
            'province' => $request->province,
            'city_municipality' => $request->city_municipality
        ]);
        return back()->withErrors(['location' => 'Invalid province or city/municipality selected.'])->withInput();
    }
    
        // Validate the request data
        $validatedData = $request->validate([
            'province' => 'required|string|max:255',
            'city_municipality' => 'required|string|max:255',
            'program' => 'required|string|max:100',
            'physical' => 'required|integer|min:0',
            'fund_utilized' => 'required|numeric|min:0',
        ]);
    
        // Convert fund_utilized to decimal
        $validatedData['fund_utilized'] = (float) $validatedData['fund_utilized'];
    
        // Override the province and city names with the PSGC codes
        $validatedData['province'] = $province->psgc;
        $validatedData['city_municipality'] = $city_municipality->psgc;
        $validatedData['program'] = $program->id;
    
        // Update the utilization with the validated data
        try {
            $utilization->update($validatedData);
            \Log::info('Utilization updated successfully for ID:', ['id' => $utilization->id]);  // Corrected log
        } catch (\Exception $e) {
            \Log::error('Error updating utilization:', ['error' => $e->getMessage()]);
            return back()->withErrors(['error' => 'Failed to update utilization.'])->withInput();
        }
    
        // Log the action of updating a utilization
        try {
            ClientLog::create([
                'user_id' => auth()->id(),
                'action' => 'edited',
                'type' => 'utilization',
                'record_id' => $utilization->id,
                'program' => $utilization->program,  // Store the program ID in the client log
            ]);
            \Log::info('Client log entry created for utilization update:', ['id' => $utilization->id]);  // Corrected log
        } catch (\Exception $e) {
            \Log::error('Error creating client log:', ['error' => $e->getMessage()]);
            return back()->withErrors(['error' => 'Failed to log the update action.']);
        }
    
        // Redirect to client reports page with a success message
        return redirect()->route('client-reports')->with('success', 'Utilization updated successfully.');
    }
    
    public function getUtilizations(Request $request)
    {
        $user = Auth::user();
        $query = Utilization::with(['province', 'citymuni', 'program'])->where('program', $user->program);
    
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
    
        // Fetch the filtered utilizations
        $utilizations = $query->get();
    
        return response()->json([
            'utilizations' => $utilizations,
        ]);
    }
    
    public function getUtilizationProvinces(Request $request)
{
    $userProgram = Auth::user()->program;

    // Fetch distinct provinces where utilizations exist for the user's program
    $utilizations = Utilization::where('program', $userProgram)
        ->with('province')
        ->get();

    // Filter out any utilizations without a valid province relationship
    $provinces = $utilizations->filter(function ($utilization) {
        return $utilization->province !== null;
    })->pluck('province')
      ->unique('psgc')
      ->values();

    \Log::info('Fetched Utilization Provinces:', $provinces->toArray());

    return response()->json(['provinces' => $provinces]);
}

   
    public function getRemainingBalance(Request $request, $utilizationId = null)
    {
        \Log::info('Received input for remaining balance', [
            'province' => $request->input('province'),
            'city_municipality' => $request->input('city_municipality'),
            'program' => $request->input('program'),
        ]);
    
        try {
            // Handle special cases for Davao City's congressional districts
            $cityMunicipalityInput = $request->input('city_municipality');
            if ($request->input('province') === '112402000') { // PSGC code for Davao City
                if ($cityMunicipalityInput === '1st Congressional District') {
                    $cityMunicipalityInput = 1;
                } elseif ($cityMunicipalityInput === '2nd Congressional District') {
                    $cityMunicipalityInput = 2;
                } elseif ($cityMunicipalityInput === '3rd Congressional District') {
                    $cityMunicipalityInput = 3;
                }
            }
    
            \Log::info('Adjusted City Municipality input:', ['city_municipality' => $cityMunicipalityInput]);
    
            // Fetch allocation
            $allocation = Allocation::where('province', $request->input('province'))
                ->where('city_municipality', $cityMunicipalityInput)
                ->where('program', $request->input('program'))
                ->first();
    
            if (!$allocation) {
                \Log::error('Allocation not found with the given parameters.', [
                    'province' => $request->input('province'),
                    'city_municipality' => $cityMunicipalityInput,
                    'program' => $request->input('program'),
                ]);
                return response()->json(['error' => 'Allocation not found'], 404);
            }
    
            \Log::info('Fetched Allocation:', [
                'province' => $allocation->province,
                'city_municipality' => $allocation->city_municipality,
                'program' => $allocation->program,
                'fund_allocation' => $allocation->fund_allocation,
            ]);
    
            // Calculate the remaining balance
            $totalUtilized = Utilization::where('province', $request->input('province'))
                ->where('city_municipality', $cityMunicipalityInput)
                ->where('program', $request->input('program'))
                ->sum('fund_utilized');
    
            \Log::info('Total Utilized for given parameters:', [
                'province' => $request->input('province'),
                'city_municipality' => $cityMunicipalityInput,
                'program' => $request->input('program'),
                'total_utilized' => $totalUtilized,
            ]);
    
            // If no previous utilization exists, remaining balance is equal to the allocation
            if ($totalUtilized == 0) {
                $remainingBalance = $allocation->fund_allocation;
            } else {
                $remainingBalance = $allocation->fund_allocation - $totalUtilized;
            }
    
            \Log::info('Remaining Balance Calculated:', [
                'remaining_balance' => $remainingBalance,
                'allocation' => $allocation->fund_allocation,
                'utilized' => $totalUtilized,
            ]);
    
            return response()->json(['remaining_balance' => $remainingBalance], 200);
        } catch (\Exception $e) {
            \Log::error('Error calculating remaining balance: ' . $e->getMessage());
            return response()->json(['error' => 'Internal server error'], 500);
        }
    }
}