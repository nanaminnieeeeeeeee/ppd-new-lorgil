<script setup>
import Layout from '../../Layouts/admin-layout.vue';
import { ref, computed, onMounted } from 'vue'; // Import `onMounted` for lifecycle hook

const today = new Date().toISOString().split('T')[0];

const props = defineProps({
  logs: Array, // logs passed as props
  clientLogs: Array, 
  programs: Array, // This will be fetched dynamically
});

const logs = ref(props.logs);
const clientLogs = ref(props.clientLogs); // Add ref for client logs
const programs = ref([]); // Initialize as empty array

// State for active tab
const activeView = ref('admin'); // 'admin' for admin logs, 'client' for client logs

const currentPage = ref(1); // Set initial page to 1
const pageSize = 10; // Show 10 logs per page

const searchDate = ref(''); // For admin logs
const searchDateClient = ref(''); // For client logs
const searchProgram = ref(''); // For program filtering

// Updated computed filtered logs based on search query
const filteredLogs = computed(() => {
  if (!searchDate.value) return logs.value;

  return logs.value.filter(log => {
    const logDate = new Date(log.created_at).toLocaleDateString('en-CA'); // Use 'en-CA' for 'YYYY-MM-DD' format
    return logDate === searchDate.value; // Compare with the search date
  });
});

// Filtered client logs based on search query
const filteredClientLogs = computed(() => {
  let filtered = clientLogs.value;

  if (searchDateClient.value) {
    filtered = filtered.filter(log => {
      const logDate = new Date(log.created_at).toLocaleDateString('en-CA');
      return logDate === searchDateClient.value;
    });
  }

  if (searchProgram.value) {
    filtered = filtered.filter(log => log.program && log.program.name === searchProgram.value);
  }

  return filtered;
});

// Paginated logs based on filtered logs
const paginatedLogs = computed(() => {
  const start = (currentPage.value - 1) * pageSize;
  const end = start + pageSize;
  return filteredLogs.value.slice(start, end);
});

// Paginated client logs
const paginatedClientLogs = computed(() => {
  const start = (currentPage.value - 1) * pageSize;
  const end = start + pageSize;
  return filteredClientLogs.value.slice(start, end);
});

// Calculate total pages for admin logs
const totalPages = computed(() => {
  return Math.ceil(filteredLogs.value.length / pageSize);
});

// Calculate total pages for client logs
const totalClientPages = computed(() => {
  return Math.ceil(filteredClientLogs.value.length / pageSize);
});

// Function to change page
const changePage = (page) => {
  if (activeView.value === 'admin') {
    if (page >= 1 && page <= totalPages.value) {
      currentPage.value = page;
    }
  } else if (activeView.value === 'client') {
    if (page >= 1 && page <= totalClientPages.value) {
      currentPage.value = page;
    }
  }
};

// Generate page numbers array
const pageNumbers = computed(() => {
  return Array.from({ length: totalPages.value }, (_, i) => i + 1);
});

const isSidebarExpanded = ref(false);

// This function updates the content layout when the sidebar is expanded or collapsed
const handleSidebarExpanded = (expanded) => {
  isSidebarExpanded.value = expanded;
};

// Fetch programs dynamically and populate the dropdown
const fetchPrograms = async () => {
  try {
    const response = await fetch('/programs');
    programs.value = await response.json();
  } catch (error) {
    console.error('Error fetching programs:', error);
  }
};

// Trigger the fetch when the component is mounted
onMounted(() => {
  fetchPrograms();
});
</script>


<template>
  <Layout @sidebar-expanded="handleSidebarExpanded"/>
   <div
     :class="{
       'ml-60': isSidebarExpanded,
       'ml-16': !isSidebarExpanded
     }"
    class="flex-1 min-h-screen p-4 transition-all duration-300 bg-gray-100" >

    <!-- Tabs for Admin Logs and Client Logs -->
    <div class="flex space-x-4 border-b border-gray-200 mb-4">
      <button
        :class="{'border-b-2 border-blue-500 font-bold text-gray-900': activeView === 'admin', 'text-gray-500': activeView !== 'admin'}"
        class="py-2 px-4 focus:outline-none"
        @click="activeView = 'admin'"
      >
        Admin Logs
      </button>
      <button
        :class="{'border-b-2 border-blue-500 font-bold text-gray-900': activeView === 'client', 'text-gray-500': activeView !== 'client'}"
        class="py-2 px-4 focus:outline-none"
        @click="activeView = 'client'"
      >
        Client Logs
      </button>
    </div>

   <!-- Conditionally Render Tables based on activeView -->
   <div v-if="activeView === 'admin'" class="bg-white p-4 rounded shadow-md max-w-full">
       
       <!-- Date filter -->
       <div class="flex justify-start items-center mb-2">
         <label for="search" class="text-sm font-medium text-gray-700 mr-4">Filter by Date:</label>
         <input
           type="date"
           id="search"
           v-model="searchDate"
           :max="today"
           class="border border-gray-300 rounded-lg px-4 py-2 text-gray-700 shadow-sm focus:ring-blue-500 focus:border-blue-500"
         />
       </div>

       <!-- Admin Logs Table -->
       <div class="overflow-x-auto">
         <table class="min-w-full bg-white rounded-lg divide-y divide-gray-200 shadow-lg">
           <thead class="bg-blue-100 text-left">
             <tr>
               <th class="w-1/12 px-6 py-3 text-xs font-bold text-gray-600 uppercase tracking-wider">Date</th>
               <th class="w-1/6 px-6 py-3 text-xs font-bold text-gray-600 uppercase tracking-wider">User</th>
               <th class="w-4/6 px-6 py-3 text-xs font-bold text-gray-600 uppercase tracking-wider">Description</th>
             </tr>
           </thead>
           <tbody class="divide-y divide-gray-200">
             <tr v-for="log in paginatedLogs" :key="log.id" class="hover:bg-blue-50 transition-colors duration-200">
              <td class="w-1/12 px-6 py-3 text-gray-800 font-semibold">
  {{ new Date(log.created_at).toLocaleString() }}
</td>
               <td class="w-1/6 px-6 py-3 text-gray-800 whitespace-nowrap overflow-hidden text-ellipsis">{{ log.user.first_name }} {{ log.user.middle_name }} {{ log.user.last_name }} {{ log.user.suffix }}</td>
               <td class="w-4/6 px-6 py-3 text-gray-800">
      <span v-if="log.action === 'role_change'">
        {{ log.user.first_name }} {{ log.user.middle_name }} {{ log.user.last_name }}'s role changed from 
        {{ log.previous_value === '0' ? 'User' : 'Admin' }} 
        to 
        {{ log.new_value === '0' ? 'User' : 'Admin' }}
      </span>
      <span v-else>
        {{ log.action }}: {{ log.previous_value }} -> {{ log.new_value }}
      </span>
    </td>
             </tr>
           </tbody>
         </table>
       </div>

       <!-- Pagination controls for admin logs -->
       <div class="mt-2 flex justify-center space-x-4 items-center">
         <button
           @click="changePage(currentPage - 1)"
           :disabled="currentPage === 1"
           class="arrow-box"
           aria-label="Previous"
         >
           <span>&lt;</span>
         </button>
         <span class="text-gray-600 font-medium text-center">
           {{ currentPage }} of {{ totalPages }}
         </span>
         <button
           @click="changePage(currentPage + 1)"
           :disabled="currentPage === totalPages"
           class="arrow-box"
           aria-label="Next"
         >
           <span>&gt;</span>
         </button>
       </div>
   </div>

   <!-- Client Logs Table -->
   <div v-else-if="activeView === 'client'" class="bg-white p-4 rounded shadow-md max-w-full mt-4">
 <!-- Date filter for client logs -->
<div class="flex flex-col sm:flex-row sm:items-center sm:justify-start mb-2 space-y-2 sm:space-y-0 sm:space-x-2">
  <input
    type="date"
    id="search-client"
    v-model="searchDateClient"
    :max="today"
    class="border border-gray-300 rounded-lg px-4 py-2 text-gray-700 shadow-sm focus:ring-blue-500 focus:border-blue-500"
  />

  <select v-model="searchProgram" 
    class="border border-gray-300 rounded-lg px-4 py-2 text-gray-700 shadow-sm focus:ring-blue-500 focus:border-blue-500">
    <option value="">All Programs</option>
    <option v-for="program in programs" :key="program.id" :value="program.name">{{ program.name }}</option>
  </select>
</div>


     <div class="overflow-x-auto">
       <table class="min-w-full bg-white rounded-lg divide-y divide-gray-200 shadow-lg">
         <thead class="bg-blue-100 text-left">
           <tr>
             <th class="w-1/12 px-6 py-3 text-xs font-bold text-gray-600 uppercase tracking-wider">Date</th>           
             <th class="w-1/6 px-6 py-3 text-xs font-bold text-gray-600 uppercase tracking-wider">Program</th>
             <th class="w-1/12 px-6 py-3 text-xs font-bold text-gray-600 uppercase tracking-wider">User</th>
             <th class="w-4/6 px-6 py-3 text-xs font-bold text-gray-600 uppercase tracking-wider">Description</th>
           </tr>
         </thead>
         <tbody class="divide-y divide-gray-200">
           <template v-if="paginatedClientLogs.length">
             <tr v-for="log in paginatedClientLogs" :key="log.id" class="hover:bg-blue-50 transition-colors duration-200">
              <td class="w-1/12 px-3 py-3 text-gray-800 font-semibold">
  {{ new Date(log.created_at).toLocaleString() }}
</td>           
               <td class="w-2/6 px-6 py-3 text-gray-800">{{ log.program ? log.program.name : 'Unknown Program' }}</td> 
               <td class="w-3/12 px-6 py-3 text-gray-800">{{ log.user.first_name }} {{ log.user.middle_name }} {{ log.user.last_name }} {{ log.user.suffix }} </td>             
               <td class="w-4/12 px-4 py-3 text-gray-800">{{ log.action }} {{ log.type }} for
                {{ log.allocation?.citymuni?.col_citymuni || log.utilization?.citymuni?.col_citymuni }}, 
                {{ log.allocation?.province?.col_province || log.utilization?.province?.col_province }}
              </td>
             </tr>
           </template>
           <template v-else>
             <tr>
               <td colspan="4" class="px-6 py-3 text-gray-500 text-center">No logs found for the selected date</td>
             </tr>
           </template>
         </tbody>
       </table>
     </div>

     <!-- Pagination controls for client logs -->
     <div class="mt-2 flex justify-center space-x-4 items-center">
       <button
         @click="changePage(currentPage - 1)"
         :disabled="currentPage === 1"
         class="arrow-box"
         aria-label="Previous"
       >
         <span>&lt;</span>
       </button>
       <span class="text-gray-600 font-medium text-center">
         {{ currentPage }} of {{ totalClientPages }}
       </span>
       <button
         @click="changePage(currentPage + 1)"
         :disabled="currentPage === totalClientPages"
         class="arrow-box"
         aria-label="Next"
       >
         <span>&gt;</span>
       </button>
     </div>
    </div>
   </div>
</template>

<style>
.arrow-box {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 30px;  /* Adjust width */
  height: 30px; /* Adjust height */
  border: 1px solid #ccc; /* Light gray border */
  border-radius: 0px;  /* Rounded corners */
  background-color: #fff; /* White background */
  font-size: 1rem; /* Smaller font size */
  padding: 0.25rem;  /* Reduced padding */
  cursor: pointer;
  transition: background-color 0.3s ease, box-shadow 0.3s ease;
}

.arrow-box:hover {
  background-color: #f1f1f1; /* Slight background color change on hover */
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1); /* Add a subtle shadow */
}

.arrow-box:disabled {
  background-color: #f9f9f9; /* Lighter background when disabled */
  color: #ccc;  /* Gray out the arrow */
  cursor: not-allowed;
}

.arrow-box span {
  font-size: 1rem;  /* Adjusted font size to match button size */
  color: #333; /* Arrow color */
}
</style>
