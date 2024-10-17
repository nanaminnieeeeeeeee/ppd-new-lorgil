<script setup>
import { reactive, ref, onMounted, watch } from 'vue';
import { Inertia } from '@inertiajs/inertia';
import debounce from 'lodash/debounce';

// Define props to receive data from parent
const props = defineProps({
  show: Boolean,
  editingItem: Object,
  programName: String,
  programStatus: Number, // Status to check if the program is restricted
});

// Emits to communicate with parent component
const emit = defineEmits(['close', 'formSubmitted']);

const form = reactive({
  province: '',
  city_municipality: '',
  program_name: '',
  program_id: '', // This must be filled correctly to trigger remaining balance fetch
  province_psgc: '',
  city_municipality_psgc: '',
  physical: '',
  fund_utilized: '',
});

const errorMessage = ref(''); // To store error message
const showSuccessModal = ref(false);

// Dropdown data for provinces and cities
const provinces = ref([]);
const cities = ref([]);
const remainingBalance = ref(null); // New ref for remaining balance
const fundUtilizedError = ref(''); // New ref for fund utilized error

onMounted(async () => {
  console.log('Component Mounted: Fetching Provinces, Cities, and User Program...');
  await fetchProvinces();
  
  if (props.editingItem) {
    await fetchCities(props.editingItem.province); // Fetch cities when editing
  }

  await fetchUserProgram(); // Fetch user's program on mount and set program_name and program_id
});

// Fetch user's program based on their program_id
const fetchUserProgram = async () => {
  try {
    const userResponse = await fetch('/user');
    const userData = await userResponse.json();

    console.log('User data fetched:', userData); // Log user data

    // Assign `program_id` from user data (note that `userData.program_id` must contain the program ID)
    form.program_id = userData.program_id ? String(userData.program_id) : ''; // Set the program ID as a string
    if (!form.program_id) {
      console.error('User program ID is missing or invalid!');
      return;
    } else {
      console.log('Assigned program_id:', form.program_id);  // Log the assigned program ID
    }

    // Assign `program_name` for display
    form.program_name = userData.program;

    // Fetch the remaining balance after setting the program details
    if (form.province_psgc && form.city_municipality_psgc && form.program_id) {
      fetchRemainingBalance();
    }
  } catch (error) {
    console.error('Error fetching user program:', error);
  }
};

watch(() => props.programName, (newProgramName) => {
  if (newProgramName) {
    form.program_name = newProgramName;
    // Fetch the user program details and assign ID
    fetchUserProgram();
  }
}, { immediate: true });

// Fetch provinces from the API
const fetchProvinces = async () => {
  try {
    const response = await fetch('/address/provinces');
    provinces.value = await response.json();
  } catch (error) {
    console.error('Error fetching provinces:', error);
  }
};

const fetchCities = async (provincePsgc) => {
  try {
    const response = await fetch(`/address/cities/${provincePsgc}`);
    const data = await response.json();
    cities.value = data; // Assign cities to the reactive variable
    return cities.value;
  } catch (error) {
    console.error('Error fetching cities:', error);
    return [];
  }
};

watch(() => form.province, async (newProvince) => {
  if (newProvince) {
    const selectedProvince = provinces.value.find(province => province.col_province === newProvince);
    if (selectedProvince) {
      form.province_psgc = selectedProvince.psgc; // Store PSGC code for backend use
      form.province = selectedProvince.col_province; // Display the name for user
      await fetchCities(selectedProvince.psgc);
    }
  }
});

watch(() => form.city_municipality, async (newCityMunicipality) => {
  if (newCityMunicipality) {
    const selectedCity = cities.value.find(city => city.col_citymuni === newCityMunicipality);
    if (selectedCity) {
      form.city_municipality_psgc = selectedCity.psgc; // Store PSGC code for backend use
      form.city_municipality = selectedCity.col_citymuni; // Display the name for user
    }
  }
});

const fetchRemainingBalance = debounce(async () => {
  if (form.province_psgc && form.city_municipality_psgc && form.program_id) {
    try {
      console.log('Requesting remaining balance with:', {
        province: form.province_psgc,
        city_municipality: form.city_municipality_psgc,
        program: form.program_id,  // Using the correct numeric program ID
      });

      const params = new URLSearchParams({
        province: form.province_psgc,
        city_municipality: form.city_municipality_psgc,
        program: form.program_id, // Correctly passing numeric ID
      });

      const response = await fetch(`/remaining-balance?${params.toString()}`);
      if (!response.ok) {
        throw new Error(`Failed to fetch remaining balance: ${response.status}`);
      }

      const data = await response.json();
      console.log('Remaining Balance Data:', data);

      if (data && data.remaining_balance !== undefined) {
        remainingBalance.value = data.remaining_balance;
        fundUtilizedError.value = ''; // Reset any previous error when balance is updated
      } else {
        console.error('Unexpected response format:', data);
        remainingBalance.value = null;
      }
    } catch (error) {
      console.error('Error fetching remaining balance:', error);
      remainingBalance.value = null;
      errorMessage.value = 'Remaining balance is not available. Please try again later.';
    }
  } else {
    remainingBalance.value = null; // Reset if any of the inputs are not selected
  }
}, 500);

watch(
  [() => form.province_psgc, () => form.city_municipality_psgc, () => form.program_id],
  ([newProvincePsgc, newCityPsgc, newProgramId]) => {
    console.log('Watcher triggered for province, city, program:', {
      province_psgc: newProvincePsgc,
      city_psgc: newCityPsgc,
      program_id: newProgramId,
    });
    if (newProvincePsgc && newCityPsgc && newProgramId) {
      console.log('All required fields are filled, fetching remaining balance...');
      fetchRemainingBalance();
    } else {
      console.log('Missing required field, cannot fetch remaining balance.');
      remainingBalance.value = null; // Reset if any value is missing
    }
  },
  { immediate: true }
);

watch(() => form.fund_utilized, (newFundUtilized) => {
  if (remainingBalance.value !== null && remainingBalance.value >= 0) {
    if (newFundUtilized > remainingBalance.value) {
      fundUtilizedError.value = 'Fund utilized cannot exceed the remaining balance.';
    } else {
      fundUtilizedError.value = ''; // Clear error if value is valid
    }
  } else {
    fundUtilizedError.value = ''; // Clear error if balance is not yet fetched
  }
});

// Reset form fields
const resetForm = () => {
  form.province = '';
  form.city_municipality = '';
  form.program_name = '';
  form.program_id = '';
  form.physical = '';
  form.fund_utilized = '';
};

watch(() => props.editingItem, async (newItem) => {
  if (newItem) {
    console.log('Editing Item:', newItem);

    // Set the province
    form.province = newItem.province.col_province;

    // Fetch cities based on the selected province PSGC
    const fetchedCities = await fetchCities(newItem.province.psgc);
    console.log('Fetched Cities:', fetchedCities);

    const newItemCityMunicipalityPSGC = String(newItem.city_municipality).trim();

    // Handle special cases for Davao City's congressional districts
    if (newItem.province.psgc === '112402000') { // PSGC code for Davao City
      if (newItem.city_municipality === '1') {
        form.city_municipality = '1st Congressional District';
      } else if (newItem.city_municipality === '2') {
        form.city_municipality = '2nd Congressional District';
      } else if (newItem.city_municipality === '3') {
        form.city_municipality = '3rd Congressional District';
      } else {
        form.city_municipality = '';
        console.warn('No city matched for Davao City Congressional District PSGC:', newItem.city_municipality);
      }
    } else {
      // For other provinces, match the city PSGC with the city_municipality in newItem
      const matchedCity = fetchedCities.find(city => String(city.psgc).trim() === String(newItem.city_municipality).trim());

      if (matchedCity) {
        form.city_municipality = matchedCity.col_citymuni; // Match by PSGC
        console.log('Matched City:', matchedCity);
      } else {
        console.warn(`No city matched for PSGC: ${newItem.city_municipality}. Available cities:`, fetchedCities);
        form.city_municipality = ''; // Reset if no match found
      }
    }

    console.log('Pre-filled City/Municipality:', form.city_municipality);

    // Pre-fill other fields
    form.program = props.programName;
    form.physical = newItem.physical;
    form.fund_utilized = newItem.fund_utilized;
  } else {
    resetForm(); // Reset if no newItem
  }
}, { immediate: true });

// Submit form logic
const submitForm = async () => {
  // Check if the program is restricted before allowing submission
  if (props.programStatus === 1) {
    errorMessage.value = "Program is restricted, submission not allowed.";  // Set the error message
    return;  // Block form submission
  }

   // Check for zero values
   if (form.physical <= 0 || form.fund_utilized <= 0) {
    errorMessage.value = "Physical and Fund Utilized cannot be zero or less.";
    return;
  }

    // Check if remaining balance is properly fetched
    if (remainingBalance.value === null) {
    errorMessage.value = "Remaining balance is not available. Please try again later.";
    return;
  }

  // Ensure fund utilized does not exceed the remaining balance
  if (form.fund_utilized > remainingBalance.value) {
    errorMessage.value = "Fund utilized cannot exceed the remaining balance.";
    return;
  }

  form.program = props.programName;

  try {
    if (props.editingItem && props.editingItem.id) {
      await Inertia.post(route('utilizations.update', props.editingItem.id), form);
      emit('formSubmitted', 'Utilization Report Updated Successfully!');
    } else {
      await Inertia.post('/utilizations', form);
      resetForm();
      emit('formSubmitted', 'Utilization Report Created Successfully!');
    }
  } catch (error) {
    console.error('Error during form submission:', error);
  }
};

// Close the modal
const close = () => {
  emit('close');
};
</script>

<template>
  <div v-if="show" class="fixed inset-0 z-50 overflow-auto bg-smoke-light flex">
    <div class="relative p-8 bg-white w-full max-w-md m-auto flex-col flex rounded-lg">
      <div class="flex justify-between items-center pb-3">
        <p class="text-2xl font-bold">Utilization Form</p>
        <button class="z-50" @click="close">Close</button>
      </div>

      <!-- Error message if submission is restricted -->
      <div v-if="errorMessage" class="text-red-500 text-center mb-4">{{ errorMessage }}</div>

      <form @submit.prevent="submitForm">
        <!-- Province Dropdown -->
        <div class="mb-2">
          <label class="block text-sm font-bold mb-1">Province</label>
          <select v-model="form.province" class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" required>
            <option value="">Select a province</option>
            <option v-for="province in provinces" :key="province.psgc" :value="province.col_province">{{ province.col_province }}</option>
          </select>
        </div>

     <!-- City/Municipality Dropdown -->
     <div class="mb-2">
          <label class="block text-sm font-bold mb-1">City/Municipality</label>
          <select v-model="form.city_municipality" class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" required>
            <option value="">Select a City/Municipality</option>
            <option v-for="city in cities" :key="city.psgc" :value="city.col_citymuni">
              {{ city.col_citymuni }}
            </option>
          </select>
        </div>

        <!-- Program Input (Read-only) -->
        <div class="mb-2">
          <label class="block text-sm font-bold mb-1">Program</label>
          <input :value="programName" type="text" class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" readonly />
        </div>

       <!-- Remaining Balance Display -->
<div class="mb-2">
  <label class="block text-sm font-bold mb-1">Remaining Fund Balance</label>
  <div class="p-2 bg-gray-100 rounded">{{ remainingBalance }}</div>
</div>
        <!-- Physical Input -->
        <div class="mb-2">
          <label class="block text-sm font-bold mb-1">Physical</label>
          <input v-model="form.physical" type="number" class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" required>
        </div>

        <!-- Fund Utilized Input -->
        <div class="mb-2">
          <label class="block text-sm font-bold mb-1">Fund Utilized</label>
          <input v-model="form.fund_utilized" type="number" step="0.01" class="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline" required>
        </div>

        <!-- Submit button or restricted message -->
        <div class="flex items-center justify-center mt-4">
          <button 
            v-if="programStatus !== 1"
            type="submit" 
            class="bg-blue-500 text-white font-bold py-2 px-4 rounded-full focus:outline-none focus:shadow-outline"
          >
            Submit
          </button>
          <!-- Show message when submission is restricted -->
          <p v-if="programStatus === 1" class="text-red-500 font-bold mt-2">
            Submission is restricted
          </p>
        </div>
      </form>
    </div>
  </div>
</template>

<style scoped>
.bg-smoke-light {
  background: rgba(0, 0, 0, 0.5);
}
</style>
