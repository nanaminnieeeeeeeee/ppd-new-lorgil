<?php

namespace App\Http\Controllers;

use App\Models\ClientLog;
use App\Models\Province;
use App\Models\CityMuni;
use App\Models\Allocation;
use App\Models\Utilization;
use Inertia\Inertia;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class CLogController extends Controller
{
    public function index()
{
    // Get the currently authenticated user
    $user = Auth::user();

    // Fetch logs based on the user's current program
    if ($user->program) {
        // Fetch logs where the program matches the user's current program
        $logs = ClientLog::with(['user', 'allocation', 'utilization'])
            ->where('program', $user->program) // Fetch logs where 'program' matches the user's program ID
            ->get()
            ->map(function ($log) {
                // Extract details (province, city/municipality, original date, etc.)
                $originalDate = 'N/A'; // Default value

                // Extract location and date information based on whether the log is for an allocation or utilization
                if ($log->type === 'allocation' && $log->allocation) {
                    $provinceName = $this->getProvinceName($log->allocation->province);
                    $cityMunicipalityName = $this->getCityMunicipalityName($log->allocation->city_municipality);
                    $originalDate = $log->allocation->created_at->toDateString(); // Get original date from allocation
                } elseif ($log->utilization) {
                    $provinceName = $this->getProvinceName($log->utilization->province);
                    $cityMunicipalityName = $this->getCityMunicipalityName($log->utilization->city_municipality);
                    $originalDate = $log->utilization->created_at->toDateString(); // Get original date from utilization
                } else {
                    $provinceName = 'Unknown Province';
                    $cityMunicipalityName = 'Unknown City/Municipality';
                }

                // Use the helper function to get the program name
                $programName = $this->getProgramName($log->program);

                return [
                    'id' => $log->id,
                    'created_at' => $log->created_at,
                    'original_date' => $originalDate, // Pass the correct original date
                    'user' => [
                        'first_name' => $log->user->first_name ?? 'Unknown User',
                        'last_name' => $log->user->last_name ?? 'Unknown User',
                        'middle_name' => $log->user->middle_name ?? 'Unknown User',
                        'suffix' => $log->user->suffix ?? 'Unknown User',
                    ],
                    'type' => $log->type,
                    'action' => $log->action,
                    'record_id' => $log->record_id,
                    'province' => $provinceName,
                    'city_municipality' => $cityMunicipalityName,
                    'description' => $cityMunicipalityName . ', ' . $provinceName,
                    'program' => $programName, // Use the program name here
                ];
            });

        // Pass the logs to the Inertia component
        return Inertia::render('Client/Client-logs', [
            'logs' => $logs,
        ]);
    } else {
        // If the user is an admin or has no program, show no logs or all logs based on your preference
        return Inertia::render('Client/Client-logs', [
            'logs' => [],  // Empty logs or show all logs for admins if required
        ]);
    }
}
    public function update(Request $request, $id)
{
    // Find the record (either allocation or utilization)
    $allocation = Allocation::find($id);
    $utilization = Utilization::find($id);

    if ($allocation) {
        // Get the program ID from the allocation
        $programId = $allocation->program;  // Fetch the program ID from the allocation
    
        \Log::info('Program ID from allocation', ['program' => $programId]); // Log the program ID for debugging

        // Update the allocation
        $allocation->update([
            'city_municipality' => $request->city_municipality, 
            'province' => $request->province, 
            'fund' => $request->fund, 
        ]);

        // Log the action in the ClientLog, including the program ID from the allocation
        ClientLog::create([
            'user_id' => Auth::id(),
            'action' => 'edited',
            'type' => 'allocation',
            'record_id' => $allocation->id,
            'description' => "Edited allocation for " . $this->getCityMunicipalityName($request->city_municipality) . ", " . $this->getProvinceName($request->province),
            'original_date' => $allocation->created_at->toDateString(),
            'program' => $programId,  // Save the program ID from the allocation
        ]);

        \Log::info('Log entry created for allocation edit.');

    } elseif ($utilization) {
        // Get the program ID from the utilization
        $programId = $utilization->program;  // Fetch the program ID from the utilization

        \Log::info('Program ID from utilization', ['program' => $programId]); // Log the program ID for debugging

        // Update the utilization
        $utilization->update([
            'city_municipality' => $request->city_municipality, 
            'province' => $request->province, 
            'physical' => $request->physical,
            'fund_utilized' => $request->fund_utilized, 
        ]);

        // Log the action in the ClientLog, including the program ID from the utilization
        ClientLog::create([
            'user_id' => Auth::id(),
            'action' => 'edited',
            'type' => 'utilization',
            'record_id' => $utilization->id,
            'description' => "Edited utilization for " . $this->getCityMunicipalityName($request->city_municipality) . ", " . $this->getProvinceName($request->province),
            'original_date' => $utilization->created_at->toDateString(),
            'program' => $programId,  // Save the program ID from the utilization
        ]);

        \Log::info('Log entry created for utilization edit.');
    }

    return back()->with('success', 'Report updated successfully.');
}

    private function getProvinceName($provincePsgc)
    {
        if (!$provincePsgc) {
            return 'N/A';
        }

        $province = Province::where('psgc', $provincePsgc)->first();
        return $province ? $province->col_province : 'Unknown Province';
    }

    private function getCityMunicipalityName($cityMuniPsgc)
    {
        if (!$cityMuniPsgc) {
            return 'N/A';
        }

        $cityMuni = CityMuni::find($cityMuniPsgc);
        return $cityMuni ? $cityMuni->col_citymuni : 'Unknown City/Municipality';
    }

    private function getProgramName($programId)
{
    if (!$programId) {
        return 'N/A';
    }

    $program = \App\Models\Program::find($programId);
    return $program ? $program->name : 'Unknown Program';
}
}