<?php

namespace App\Http\Controllers;

use App\Models\Log;
use App\Models\ClientLog; // Import the ClientLog model
use Inertia\Inertia;
use App\Models\Allocation;
use App\Models\Utilization;


class LogController extends Controller
{
    public function index()
    {
        // Fetch all admin logs with specific fields and associated user details
        $logs = Log::with([
            'user:id,first_name,middle_name,last_name,suffix',
          
        ])
        ->select('id', 'user_id', 'action', 'previous_value', 'new_value', 'created_at')
        ->get(); // Fetch all logs without filtering

        // Fetch all client logs with associated users and programs
        $clientLogs = ClientLog::with([
            'user:id,first_name,middle_name,last_name,suffix',
            'program:id,name', 
            'allocation.province:psgc,col_province', 
            'allocation.citymuni:psgc,col_citymuni', 
            'utilization.province:psgc,col_province', 
            'utilization.citymuni:psgc,col_citymuni', 
        ])
        ->select('id', 'user_id', 'program', 'action','type', 'record_id', 'created_at') 
        ->get();

        // Pass both admin logs and client logs to the Vue component
        return Inertia::render('Admin/Admin-logs', [
            'logs' => $logs,
            'clientLogs' => $clientLogs, // Add client logs here
        ]);
    }
}