<template>
    <div>
      <h1>Hello, {{ user.first_name }}!</h1>
      <p>Your account has been approved. You can now log in and access the platform.</p>
      <p>Thank you!</p>
    </div>
  </template>
  
  <script setup>
  import { ref } from 'vue';
  
  // The `user` prop should be passed down when this component is used
  const props = defineProps({
    user: {
      type: Object,
      required: true
    }
  });
  </script>
  