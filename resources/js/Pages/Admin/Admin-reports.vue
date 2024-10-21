<script setup>
import { ref, computed, onMounted } from 'vue';
import { defineProps } from 'vue';
import Layout from '../../Layouts/admin-layout.vue';
import { generatePptReport } from './pptformat';
import { generateProgramPpt } from './pptprogram';

// State for the selected province and program
const selectedProvince = ref('all'); 
const selectedProgram = ref(''); 


// Function to generate province-based PPT report with unified year and quarter filters
const generatePpt = () => {
  // Ensure that year and quarter are selected
  if (!selectedYear.value || !selectedQuarter.value) {
    console.error('Please select both year and quarter to generate the report');
    return;
  }

  // Check if 'all' provinces are selected
  if (selectedProvince.value === 'all') {
    if (!props.provinces.length) {
      console.error('No provinces available to generate the report');
      return;
    }

    if (!props.programs.length) {
      console.error('No programs available to generate the report');
      return;
    }

    // Move Davao City to the top of the provinces list
    const sortedProvinces = [...props.provinces];
    const davaoCityIndex = sortedProvinces.findIndex(
      (province) => province.col_province.toLowerCase() === 'davao city'
    );

    if (davaoCityIndex !== -1) {
      const davaoCity = sortedProvinces.splice(davaoCityIndex, 1)[0];
      sortedProvinces.unshift(davaoCity);
    }

    // Prepare the data for generating the report
    const allProvinces = sortedProvinces.map((province) => {
      const groupedCityMunicipalities = province.districts || {};
      const allCityMunicipalities = Object.values(groupedCityMunicipalities).flatMap((districtGroup) => {
        return districtGroup.cities ? districtGroup.cities : [];
      });

      return {
        ...province,
        cities: allCityMunicipalities,
      };
    });

    // Generate the report for all provinces with unified year and quarter filters
    generatePptReport(
      allProvinces,
      props.programs,
      selectedYear.value,
      selectedQuarter.value,
      'All Provinces'
    );
  } else {
    // Handle single province selection
    const groupedCityMunicipalities = selectedProvince.value.districts || {};
    const allCityMunicipalities = Object.values(groupedCityMunicipalities).flatMap((districtGroup) => {
      return districtGroup.cities ? districtGroup.cities : [];
    });

    if (!allCityMunicipalities.length) {
      console.error('No city/municipality data available for the selected province');
      return;
    }

    const provinceName = selectedProvince.value.col_province;

    // Generate the report for the selected province with unified year and quarter filters
    generatePptReport(
      [selectedProvince.value],
      props.programs,
      selectedYear.value,
      selectedQuarter.value,
      provinceName
    );
  }
};

// Function to generate program-based PPT report
const handleGeneratePpt = () => {
  if (selectedProvince.value === 'all') {
    const sortedProvinces = [...props.provinces];
    const davaoCityIndex = sortedProvinces.findIndex(province => province.col_province.toLowerCase() === 'davao city');

    if (davaoCityIndex !== -1) {
      const davaoCity = sortedProvinces.splice(davaoCityIndex, 1)[0];
      sortedProvinces.unshift(davaoCity);
    }

    const allProvinces = sortedProvinces.map(province => {
      const groupedCityMunicipalities = province.districts || {};
      const allCityMunicipalities = Object.values(groupedCityMunicipalities).flatMap(districtGroup => {
        return districtGroup.cities ? districtGroup.cities : [];
      });

      return {
        ...province,
        cities: allCityMunicipalities
      };
    });

    generateProgramPpt(allProvinces, props.programs, [], 'All Provinces', selectedYear.value, selectedQuarter.value);
  } else {
    const groupedCityMunicipalities = selectedProvince.value.districts || {};
    const allCityMunicipalities = Object.values(groupedCityMunicipalities).flatMap(districtGroup => {
      return districtGroup.cities ? districtGroup.cities : [];
    });

    const provinceName = selectedProvince.value.col_province;

    generateProgramPpt([selectedProvince.value], props.programs, allCityMunicipalities, provinceName, selectedYear.value, selectedQuarter.value);
  }
};


// Function to convert district number to ordinal (1st, 2nd, 3rd, etc.)
const getOrdinal = (number) => {
  if (number === 1) return '1st';
  if (number === 2) return '2nd';
  if (number === 3) return '3rd';
  return `${number}th`; // For any other number (4th, 5th, etc.)
};

const props = defineProps({
  provinces: Array, // provinces with their associated districts and cities/municipalities
  programs: Array, // Array for programs data
});

// State to switch between views
const activeView = ref('provinces');

// Move Davao City to the top
const sortedProvinces = computed(() => {
  const provincesCopy = [...props.provinces];

  const davaoCityIndex = provincesCopy.findIndex(province => province.col_province.toLowerCase() === 'davao city');
  
  if (davaoCityIndex !== -1) {
    const davaoCity = provincesCopy.splice(davaoCityIndex, 1)[0]; 
    provincesCopy.unshift(davaoCity); 
  }

  return provincesCopy;
});

// State to track expanded provinces
const expandedProvince = ref(null);

const toggleProvince = (provincePsgc) => {
  expandedProvince.value = expandedProvince.value === provincePsgc ? null : provincePsgc;
};

// Function to calculate percentage variance
const calculatePercentageVariance = (value1, value2) => {
  if (value1 === undefined || value2 === undefined) return '0';
  if (value1 === 0 || value2 === 0) return '0'; // If either value is 0, return 0
  if (value1 === 0) return '0%'; 
  
  const variance = ((value1 - value2) / value1) * 100;
  return variance.toFixed(2) + '%';
};


// Search and download functionality
const searchQuery = ref('');
const fromDate = ref(''); // From date input
const toDate = ref(''); // To date input

// Filtered Provinces year, quarter, and Selected Program
const filteredProvinces = computed(() => {
  let filtered = sortedProvinces.value;

  // Filter by search query (province name)
  if (searchQuery.value) {
    filtered = filtered.filter(province =>
      province.col_province.toLowerCase().includes(searchQuery.value.toLowerCase())
    );
  }

  // Filter by from and to dates
  if (fromDate.value && toDate.value) {
    const from = new Date(fromDate.value);
    const to = new Date(toDate.value);

    filtered = filtered.filter(province => {
      const provinceDate = new Date(province.date);
      return provinceDate >= from && provinceDate <= to;
    });
  }

  // Filter by selected program
  if (selectedProgram.value && selectedProgram.value !== 'all') {
    filtered = filtered.filter(province => {
      // Check if the province has data for the selected program
      const hasProgram = province.programs && province.programs.some(program => 
        program.program_id === selectedProgram.value.id
      );

      if (hasProgram) {
        // Update the province's totals to show only the selected program's data
        return {
          ...province,
          total_target: province.programs.find(p => p.program_id === selectedProgram.value.id).target || 0,
          total_physical: province.programs.find(p => p.program_id === selectedProgram.value.id).physical || 0,
          total_allocation: province.programs.find(p => p.program_id === selectedProgram.value.id).allocation || 0,
          total_utilization: province.programs.find(p => p.program_id === selectedProgram.value.id).utilization || 0,
          // Update districts data to show only selected program data
          districts: Object.fromEntries(
            Object.entries(province.districts || {}).map(([key, district]) => [
              key,
              {
                ...district,
                cities: district.cities.map(city => ({
                  ...city,
                  total_target: city.programs?.find(p => p.program_id === selectedProgram.value.id)?.target || 0,
                  total_physical: city.programs?.find(p => p.program_id === selectedProgram.value.id)?.physical || 0,
                  total_allocation: city.programs?.find(p => p.program_id === selectedProgram.value.id)?.allocation || 0,
                  total_utilization: city.programs?.find(p => p.program_id === selectedProgram.value.id)?.utilization || 0,
                }))
              }
            ])
          )
        };
      }
      return false;
    });
  }

  return filtered;
});


// Filtered Programs based on selected program
const filteredPrograms = computed(() => {
  if (!selectedProgram.value) {
    return props.programs; // Show all programs if none is selected
  }
  return props.programs.filter(program => program.id === selectedProgram.value.id); // Filter based on selected program's ID
});

const isSidebarExpanded = ref(false);

// This function updates the content layout when the sidebar is expanded or collapsed
const handleSidebarExpanded = (expanded) => {
  isSidebarExpanded.value = expanded;
};

// State for selected year and quarter for the table (independent from modal)
const selectedYear = ref('all');
const selectedQuarter = ref('all');

// Define options for year and quarter
const years = [2022, 2023, 2024, 2025,2026];  
const quarters = [1, 2, 3, 4];

// Function to reload the page with selected year and quarter for the table filtering
const applyFilter = () => {
  const yearParam = selectedYear.value !== 'all' ? `year=${selectedYear.value}` : '';
  const quarterParam = selectedQuarter.value !== 'all' ? `quarter=${selectedQuarter.value}` : '';
  const programParam = selectedProgram.value && selectedProgram.value !== 'all' 
    ? `program=${selectedProgram.value.id}` 
    : '';


  // Build query string
  const queryParams = [yearParam, quarterParam, programParam]
    .filter(Boolean)
    .join('&');

  // Reload the page with the new parameters
  const url = queryParams ? `?${queryParams}` : window.location.pathname;
  window.location.href = url;
};

// Function to parse URL query parameters and set the selected year and quarter for the table
const getQueryParams = () => {
  const params = new URLSearchParams(window.location.search);
  const year = params.get('year') || 'all';
  const quarter = params.get('quarter') || 'all';
  const program = params.get('program') || 'all';

  selectedYear.value = year;
  selectedQuarter.value = quarter;

  // Make sure props.programs exists and has items before searching
  if (program !== 'all' && props.programs && props.programs.length > 0) {
    const programObj = props.programs.find(p => p.id && p.id.toString() === program);
    
    if (programObj) {
      selectedProgram.value = programObj;
    }
  } else {
    selectedProgram.value = 'all';
  }
};


onMounted(() => {
  getQueryParams();
});

const modalOpen = ref(false);
const openModal = () => {
  modalOpen.value = true;
};

// Function to close the modal
const closeModal = () => {
  modalOpen.value = false;
};

</script>

<template>
  <Layout @sidebar-expanded="handleSidebarExpanded"/>
    <div
      :class="{
        'ml-60': isSidebarExpanded,
        'ml-16': !isSidebarExpanded
      }"
      class="flex-1 min-h-screen p-4 transition-all duration-300 bg-gray-100" >

      <div class="bg-white p-6 rounded shadow-md max-w-full mx-auto">
        
  
      <div class="flex justify-between mb-2 space-x-4">
          <!-- Filter Section (Inline with Title) -->
          <div class="flex flex-col gap-4 sm:flex-row sm:justify-between mb-2">
    <!-- Filter Controls Group -->
    <div class="flex flex-col sm:flex-row gap-2 sm:gap-4 w-full sm:items-center">
      <!-- Year and Quarter Filters - Stack on mobile, inline on desktop -->
      <div class="flex gap-2 w-full sm:w-auto">
        <select 
          v-model="selectedYear" 
          class="w-full sm:w-32 p-2 border rounded-md focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
        >
          <option value="all">All Years</option>
          <option v-for="year in years" :value="year" :key="year">
            {{ year }}
          </option>
        </select>

        <select 
          v-model="selectedQuarter" 
          class="w-full sm:w-36 p-2 border rounded-md focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
        >
          <option value="all">All Quarters</option>
          <option v-for="quarter in quarters" :value="quarter" :key="quarter">
            Quarter {{ quarter }}
          </option>
        </select>
      </div>

      <!-- Program Selection with Search Button 
      <div class="flex gap-2 w-full sm:w-auto">
        <select 
          v-model="selectedProgram" 
          class="w-full sm:w-64 px-4 py-2 border border-gray-300 rounded-md focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
        >
          <option value="" disabled>Select Program</option>
          <option value="all">All Programs</option>
          <option 
            v-for="program in programs" 
            :key="program.id" 
            :value="program"
          >
            {{ program.program_name }}
          </option>
        </select>-->

        <!-- Search Button -->
        <button
          @click="applyFilter"
          class="flex-shrink-0 bg-blue-500 hover:bg-blue-600 text-white font-bold p-2 rounded transition-colors"
          aria-label="Apply filter"
        >
          <svg 
            class="h-6 w-6 text-slate-100" 
            viewBox="0 0 24 24" 
            fill="none" 
            stroke="currentColor" 
            stroke-width="2" 
            stroke-linecap="round" 
            stroke-linejoin="round"
          >
            <circle cx="11" cy="11" r="8" />
            <line x1="21" y1="21" x2="16.65" y2="16.65" />
          </svg>
        </button>
   
    </div>

    <!-- Export Button - Always on right -->
    <button 
      @click="openModal" 
      class="flex items-center justify-center gap-2 bg-blue-500 hover:bg-blue-700 text-white px-4 py-2 rounded-md transition-colors w-full sm:w-auto flex-shrink-0"
    >
      <svg 
        class="h-5 w-5 text-slate-100" 
        viewBox="0 0 24 24" 
        fill="none" 
        stroke="currentColor" 
        stroke-width="2" 
        stroke-linecap="round" 
        stroke-linejoin="round"
      >
        <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
        <polyline points="7 10 12 15 17 10" />
        <line x1="12" y1="15" x2="12" y2="3" />
      </svg>
      <span class="sm:hidden">Download</span>
    </button>
  </div>
        <!-- Modal -->
      <div v-if="modalOpen" class="fixed inset-0 z-50 flex items-center justify-center bg-gray-800 bg-opacity-75">
        <div class="bg-white p-6 rounded-md shadow-lg w-full max-w-lg">
          <h2 class="text-xl text-center font-bold mb-4">Download Report</h2>

          <!-- Modal Year Selection 
          <select v-model="selectedYear" class="px-4 py-2 mb-4 border rounded-md w-full">
            <option value="all">All Years</option>
            <option v-for="year in years" :value="year" :key="year">{{ year }}</option>
          </select>

           Modal Quarter Selection 
          <select v-model="selectedQuarter" class="px-4 py-2 mb-4 border rounded-md w-full">
            <option value="all">All Quarters</option>
            <option v-for="quarter in quarters" :value="quarter" :key="quarter">Quarter {{ quarter }}</option>
          </select>-->

             <!-- Province Selection Dropdown -->
             <select v-model="selectedProvince" class="px-4 py-2 mb-4 border border-gray-300 rounded-md w-full">
              <option value="" disabled>Select Province</option>
              <option value="all">All Provinces</option>
              <option v-for="province in sortedProvinces" :key="province.psgc" :value="province">
                {{ province.col_province }}
              </option>
            </select>
            <div class="flex space-x-2">
  <!-- Province Button -->
  <button @click="generatePpt" class="bg-blue-500 text-white px-4 py-2 rounded-md hover:bg-blue-700 w-full">
    Province Report
  </button>

  <!-- Program Button -->
  <button @click="handleGeneratePpt" class="bg-blue-500 text-white px-4 py-2 rounded-md hover:bg-blue-700 w-full ">
    Program Report
  </button>
</div>

<!-- Close Modal Button -->
<div class="flex justify-center">
  <button @click="closeModal" class="inline-block mt-4 align-baseline font-bold text-sm text-red-600 hover:text-red-800">
    <u>Close</u>
  </button>
        </div>
      </div>
    </div>
    </div>

        <!-- Tabs for switching views -->
        <div class="flex space-x-4 border-b border-gray-200 mb-4">
          <button
            :class="{'border-b-2 border-blue-500 font-bold text-gray-900': activeView === 'provinces', 'text-gray-500': activeView !== 'provinces'}"
            class="py-2 px-4 focus:outline-none"
            @click="activeView = 'provinces'"
          >
            Provinces
          </button>
          <button
            :class="{'border-b-2 border-blue-500 font-bold text-gray-900': activeView === 'programs', 'text-gray-500': activeView !== 'programs'}"
            class="py-2 px-4 focus:outline-none"
            @click="activeView = 'programs'"
          >
            Programs
          </button>
        </div>

        <!-- Conditionally render tables based on activeView -->
        <div v-if="activeView === 'provinces'">
          <!-- Provinces Table -->
          <div class="overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-200">
              <thead class="bg-blue-100">
                <tr>
                  <th class="px-6 py-3 text-left text-xs font-bold text-gray-600 uppercase tracking-wider">Province</th>
                  <th class="px-6 py-3 text-left text-xs font-bold text-gray-600 uppercase tracking-wider">Target</th>
                  <th class="px-6 py-3 text-left text-xs font-bold text-gray-600 uppercase tracking-wider">Served</th>
                  <th class="px-6 py-3 text-left text-xs font-bold text-gray-600 uppercase tracking-wider">Variance (Physical)</th>
                  <th class="px-6 py-3 text-left text-xs font-bold text-gray-600 uppercase tracking-wider">Allocation</th>
                  <th class="px-6 py-3 text-left text-xs font-bold text-gray-600 uppercase tracking-wider">Utilization</th>
                  <th class="px-6 py-3 text-left text-xs font-bold text-gray-600 uppercase tracking-wider">Variance (Financial)</th>
                </tr>
              </thead>

              <tbody class="bg-white divide-y divide-gray-200">
                <template v-for="province in filteredProvinces" :key="province.psgc">
                  <tr class="hover:bg-blue-50 transition-colors duration-200">
                    <td class="px-8 py-2 whitespace-nowrap">
                      <div @click="toggleProvince(province.psgc)" class="cursor-pointer">
                        <strong>{{ province.col_province }}</strong>
                      </div>
                    </td>
                    <td class="px-8 py-2 whitespace-nowrap">{{ province.total_target }}</td> 
                    <td class="px-8 py-2 whitespace-nowrap">{{ province.total_physical }}</td> 
                    <td class="px-8 py-2 whitespace-nowrap">{{ calculatePercentageVariance(province.total_target, province.total_physical) }}</td> 
                    <td class="px-8 py-2 whitespace-nowrap">{{ province.total_allocation }}</td> 
                    <td class="px-8 py-2 whitespace-nowrap">{{ province.total_utilization }}</td> 
                    <td class="px-8 py-2 whitespace-nowrap">{{ calculatePercentageVariance(province.total_allocation, province.total_utilization) }}</td> 
                  </tr>
                  <!-- City/Municipality data below each province -->
                  <tr v-if="expandedProvince === province.psgc">
                    <td colspan="7" class="px-8 py-4"> 
                      <div class="bg-gray-50 p-4 rounded-lg mb-4">
                        <div v-for="(district, districtKey) in province.districts" :key="districtKey">
                          <div v-if="districtKey && parseInt(districtKey)" class="font-bold mb-2">
                            {{ getOrdinal(parseInt(districtKey)) }} Congressional District
                          </div>
                          <table class="min-w-full divide-y divide-gray-200 mt-2 border border-blue-400">
                            <thead class="bg-blue-100">
                              <tr>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">City/Municipality</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Target</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Physical</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Variance (Physical)</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Allocation</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Utilization</th>
                                <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Variance (Financial)</th>
                              </tr>
                            </thead>
                            <tbody class="bg-white divide-y divide-gray-200">
                              <tr v-for="city in district.cities" :key="city.col_citymuni" class="hover:bg-blue-50 transition-colors duration-200">
                                <td class="px-8 py-2 whitespace-nowrap">{{ city.col_citymuni }}</td>
                                <td class="px-8 py-2 whitespace-nowrap">{{ city.total_target }}</td>
                                <td class="px-8 py-2 whitespace-nowrap">{{ city.total_physical }}</td>
                                <td class="px-8 py-2 whitespace-nowrap">{{ calculatePercentageVariance(city.total_target, city.total_physical) }}</td>
                                <td class="px-8 py-2 whitespace-nowrap">{{ city.total_allocation }}</td>
                                <td class="px-8 py-2 whitespace-nowrap">{{ city.total_utilization }}</td>
                                <td class="px-8 py-2 whitespace-nowrap">{{ calculatePercentageVariance(city.total_allocation, city.total_utilization) }}</td>
                              </tr>
                            </tbody>
                          </table>
                        </div>
                      </div>
                    </td>
                  </tr>
                </template>
              </tbody>
            </table>
          </div>
        </div>

        <!-- Programs Table -->
        <div v-else-if="activeView === 'programs'">
          <div class="overflow-x-auto">
            <table class="min-w-full divide-y divide-gray-200">
              <thead class="bg-blue-100">
                <tr>
                  <th class="px-6 py-3 text-left text-xs font-bold text-gray-600 uppercase tracking-wider">Program Name</th>
                  <th class="px-6 py-3 text-left text-xs font-bold text-gray-600 uppercase tracking-wider">Target</th>
                  <th class="px-6 py-3 text-left text-xs font-bold text-gray-600 uppercase tracking-wider">Served</th>
                  <th class="px-6 py-3 text-left text-xs font-bold text-gray-600 uppercase tracking-wider">Variance (Physical)</th>
                  <th class="px-6 py-3 text-left text-xs font-bold text-gray-600 uppercase tracking-wider">Allocation</th>
                  <th class="px-6 py-3 text-left text-xs font-bold text-gray-600 uppercase tracking-wider">Utilization</th>
                  <th class="px-6 py-3 text-left text-xs font-bold text-gray-600 uppercase tracking-wider">Variance (Financial)</th>
                </tr>
              </thead>

              <tbody class="bg-white divide-y divide-gray-200">
                <tr v-for="program in filteredPrograms" :key="program.id" class="hover:bg-blue-50 transition-colors duration-200">
                  <td class="px-8 py-2 whitespace-nowrap flex items-center">
                    <img
                      v-if="program.program_logo"
                      :src="program.program_logo"
                      alt="Program Logo"
                      class="w-8 h-8 mr-2 rounded-full"
                    />
                    <strong>{{ program.program_name }}</strong>
                  </td>

                  <td class="px-8 py-2 whitespace-nowrap">{{ program.total_target }}</td> <!-- Increased padding -->
                  <td class="px-8 py-2 whitespace-nowrap">{{ program.total_physical }}</td> <!-- Increased padding -->
                  <td class="px-8 py-2 whitespace-nowrap">{{calculatePercentageVariance(program.total_target, program.total_physical) }}</td>
                  <td class="px-8 py-2 whitespace-nowrap">{{ program.total_allocation }}</td> <!-- Increased padding -->
                  <td class="px-8 py-2 whitespace-nowrap">{{ program.total_utilization }}</td> <!-- Increased padding -->
                  <td class="px-8 py-2 whitespace-nowrap">{{calculatePercentageVariance(program.total_allocation, program.total_utilization) }}</td> 
                </tr>
              </tbody>
            </table>
          </div>
        </div>
        
      </div>
    </div>
</template>
