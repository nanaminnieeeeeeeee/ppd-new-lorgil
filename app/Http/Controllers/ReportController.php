<?php

namespace App\Http\Controllers;

use App\Models\Program;
use App\Models\Province;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;

class ReportController extends Controller
{
    public function index(Request $request)
    {
        // Fetch selected year, quarter, and program from the request, default to 'all' if not provided
        $selectedYear = $request->input('year', 'all');
        $selectedQuarter = $request->input('quarter', 'all');

        // Available years for the filter (e.g., last 5 years including the current year)
        $availableYears = range(date('Y'), date('Y') - 5);

        // Available quarters
        $availableQuarters = [1, 2, 3, 4];

        // Fetch all programs for the program filter dropdown
        $allPrograms = Program::select('id', 'name')->get();

        // Fetch all provinces along with their associated city municipalities, allocations, and utilizations
        $provinces = Province::with(['citymuni.allocations' => function ($query) use ($selectedYear, $selectedQuarter) {
            if ($selectedYear !== 'all') {
                $query->whereYear('created_at', $selectedYear);
            }
            if ($selectedQuarter !== 'all') {
                $query->where(DB::raw('QUARTER(created_at)'), $selectedQuarter);
            }
        }, 'citymuni.utilizations' => function ($query) use ($selectedYear, $selectedQuarter) {
            if ($selectedYear !== 'all') {
                $query->whereYear('created_at', $selectedYear);
            }
            if ($selectedQuarter !== 'all') {
                $query->where(DB::raw('QUARTER(created_at)'), $selectedQuarter);
            }
        }])->get();

        // Group cities by province and district, including allocation and utilization data
        $groupedProvinces = $provinces->map(function ($province) use ($selectedYear, $selectedQuarter) {
            $groupedCities = $province->citymuni->groupBy('district');

            $totalProvinceAllocation = $province->citymuni->flatMap->allocations->sum('fund_allocation');
            $totalProvinceUtilization = $province->citymuni->flatMap->utilizations->sum('fund_utilized');
            $totalProvinceTarget = $province->citymuni->flatMap->allocations->sum('target');
            $totalProvincePhysical = $province->citymuni->flatMap->utilizations->sum('physical');

            return [
                'psgc' => $province->psgc,
                'col_province' => $province->col_province,
                'total_allocation' => $totalProvinceAllocation,
                'total_utilization' => $totalProvinceUtilization,
                'total_target' => $totalProvinceTarget,
                'total_physical' => $totalProvincePhysical,
                'districts' => $groupedCities->mapWithKeys(function ($cities, $district) use ($selectedYear, $selectedQuarter) {
                    return [$district => [
                        'district' => $district,
                        'cities' => $cities->map(function ($city) use ($selectedYear, $selectedQuarter) {
                            $totalAllocation = $city->allocations->sum('fund_allocation');
                            $totalUtilization = $city->utilizations->sum('fund_utilized');
                            $totalTarget = $city->allocations->sum('target');
                            $totalPhysical = $city->utilizations->sum('physical');

                            $programsByCity = DB::table('programs')
                                ->leftJoin(DB::raw("(SELECT program, city_municipality, SUM(target) as total_target, SUM(fund_allocation) as total_allocation
                                                     FROM allocations
                                                     WHERE city_municipality = ?
                                                     " . ($selectedYear !== 'all' ? "AND YEAR(created_at) = ?" : '') . "
                                                     " . ($selectedQuarter !== 'all' ? "AND QUARTER(created_at) = ?" : '') . "
                                                     GROUP BY program, city_municipality) as alloc"), 'programs.id', '=', 'alloc.program')
                                ->leftJoin(DB::raw("(SELECT program, city_municipality, SUM(physical) as total_physical, SUM(fund_utilized) as total_utilization
                                                     FROM utilizations
                                                     WHERE city_municipality = ?
                                                     " . ($selectedYear !== 'all' ? "AND YEAR(created_at) = ?" : '') . "
                                                     " . ($selectedQuarter !== 'all' ? "AND QUARTER(created_at) = ?" : '') . "
                                                     GROUP BY program, city_municipality) as util"), 'programs.id', '=', 'util.program')
                                ->select(
                                    'programs.id as program_id',
                                    'programs.name as program_name',
                                    'programs.logo as program_logo',
                                    DB::raw('COALESCE(alloc.total_target, 0) as total_target'),
                                    DB::raw('COALESCE(util.total_physical, 0) as total_physical'),
                                    DB::raw('COALESCE(alloc.total_allocation, 0) as total_allocation'),
                                    DB::raw('COALESCE(util.total_utilization, 0) as total_utilization')
                                )
                                ->setBindings(array_merge(
                                    [$city->psgc],
                                    ($selectedYear !== 'all' ? [$selectedYear] : []),
                                    ($selectedQuarter !== 'all' ? [$selectedQuarter] : []),
                                    [$city->psgc],
                                    ($selectedYear !== 'all' ? [$selectedYear] : []),
                                    ($selectedQuarter !== 'all' ? [$selectedQuarter] : [])
                                ))
                                ->get()
                                ->map(function ($program) {
                                    return [
                                        'program_id' => $program->program_id,
                                        'program_name' => $program->program_name,
                                        'program_logo' => $program->program_logo,
                                        'total_target' => $program->total_target,
                                        'total_physical' => $program->total_physical,
                                        'total_allocation' => $program->total_allocation,
                                        'total_utilization' => $program->total_utilization,
                                    ];
                                });

                            return [
                                'psgc' => $city->psgc,
                                'col_citymuni' => $city->col_citymuni,
                                'total_allocation' => $totalAllocation,
                                'total_utilization' => $totalUtilization,
                                'total_target' => $totalTarget,
                                'total_physical' => $totalPhysical,
                                'programs' => $programsByCity,
                            ];
                        }),
                    ]];
                }),
            ];
        });

        // Fetch all programs data for the dashboard with filtering based on selectedYear and selectedQuarter
        $programs = DB::table('programs')
            ->leftJoin(DB::raw("(SELECT program, SUM(target) as total_target, SUM(fund_allocation) as total_allocation
                                 FROM allocations
                                 " . (($selectedYear !== 'all' || $selectedQuarter !== 'all') ? "WHERE " : "") . "
                                 " . ($selectedYear !== 'all' ? "YEAR(created_at) = $selectedYear" : "") . "
                                 " . ($selectedYear !== 'all' && $selectedQuarter !== 'all' ? " AND " : "") . "
                                 " . ($selectedQuarter !== 'all' ? "QUARTER(created_at) = $selectedQuarter" : "") . "
                                 GROUP BY program) as alloc"), 'programs.id', '=', 'alloc.program')
            ->leftJoin(DB::raw("(SELECT program, SUM(physical) as total_physical, SUM(fund_utilized) as total_utilization
                                 FROM utilizations
                                 " . (($selectedYear !== 'all' || $selectedQuarter !== 'all') ? "WHERE " : "") . "
                                 " . ($selectedYear !== 'all' ? "YEAR(created_at) = $selectedYear" : "") . "
                                 " . ($selectedYear !== 'all' && $selectedQuarter !== 'all' ? " AND " : "") . "
                                 " . ($selectedQuarter !== 'all' ? "QUARTER(created_at) = $selectedQuarter" : "") . "
                                 GROUP BY program) as util"), 'programs.id', '=', 'util.program')
            ->select(
                'programs.id as program_id',
                'programs.name as program_name',
                'programs.logo as program_logo',
                DB::raw('COALESCE(alloc.total_target, 0) as total_target'),
                DB::raw('COALESCE(util.total_physical, 0) as total_physical'),
                DB::raw('COALESCE(alloc.total_allocation, 0) as total_allocation'),
                DB::raw('COALESCE(util.total_utilization, 0) as total_utilization')
            )
            ->groupBy('programs.id', 'programs.name', 'programs.logo', 'alloc.total_target', 'util.total_physical', 'alloc.total_allocation', 'util.total_utilization')
            ->get()
            ->map(function ($program) {
                return [
                    'program_id' => $program->program_id,
                    'program_name' => $program->program_name,
                    'program_logo' => $program->program_logo,
                    'total_target' => $program->total_target,
                    'total_physical' => $program->total_physical,
                    'total_allocation' => $program->total_allocation,
                    'total_utilization' => $program->total_utilization,
                ];
            });

        // Render the view with grouped provinces and programs
        return Inertia::render('Admin/Admin-reports', [
            'provinces' => $groupedProvinces,
            'allPrograms' => $allPrograms,
            'selectedYear' => $selectedYear,
            'selectedQuarter' => $selectedQuarter,
            'availableYears' => $availableYears,
            'availableQuarters' => $availableQuarters,
            'programs' => $programs,
        ]);
    }
}
