import PptxGenJS from 'pptxgenjs';

// Function to convert district number to ordinal (1st, 2nd, 3rd, etc.)
const getOrdinal = (number) => {
  if (number === 1) return '1st';
  if (number === 2) return '2nd';
  if (number === 3) return '3rd';
  return `${number}th`; // For any other number (4th, 5th, etc.)
};

// Main function to generate the PowerPoint file based on the selected year, quarter, and province filters
const generatePpt = () => {
  // Ensure that both year and quarter are selected
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
    const davaoCityIndex = sortedProvinces.findIndex(province => province.col_province.toLowerCase() === 'davao city');
    
    if (davaoCityIndex !== -1) {
      const davaoCity = sortedProvinces.splice(davaoCityIndex, 1)[0];
      sortedProvinces.unshift(davaoCity);
    }

    // Prepare the data for generating the report for all provinces
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

    // Generate the report for all provinces
    generatePptReport(allProvinces, props.programs, selectedYear.value, selectedQuarter.value, 'All_Provinces');
  } else {
    // Handle single province selection
    const groupedCityMunicipalities = selectedProvince.value.districts || {};
    const allCityMunicipalities = Object.values(groupedCityMunicipalities).flatMap(districtGroup => {
      return districtGroup.cities ? districtGroup.cities : [];
    });

    if (!allCityMunicipalities.length) {
      console.error('No city/municipality data available for the selected province');
      return;
    }

    const provinceName = selectedProvince.value.col_province;

    // Generate the report for the selected province
    generatePptReport([selectedProvince.value], props.programs, selectedYear.value, selectedQuarter.value, provinceName);
  }
};

// Function to format and generate PowerPoint report with selectedYear and selectedQuarter filters
export const generatePptReport = (provinces, programs, selectedYear, selectedQuarter, provinceName) => {
  const pptx = new PptxGenJS();

  // Iterate over each province
  provinces.forEach(province => {
    // Slide 1: Province Overview
    const firstSlide = pptx.addSlide();
    firstSlide.background = { path: `${window.location.origin}/ppd-images/ppt-bg.png` };

    // Add province name as the main title
    firstSlide.addText(province.col_province.toUpperCase(), { 
      x: '-10%', y: '42%', w: '100%', fontSize: 44, bold: true, color: '00072D', fontFace: 'Arial', align: 'center' 
    });

    // Add "TARGET AND ACCOMPLISHMENT" below the province name
    firstSlide.addText('TARGET AND ACCOMPLISHMENT', { 
      x: '-10%', y: '52%', w: '100%', fontSize: 28, bold: true, color: '00072D', fontFace: 'Arial', align: 'center' 
    });

    // Add current date for the slide in long format
    const options = { year: 'numeric', month: 'long', day: 'numeric' };
    const currentDate = new Date().toLocaleDateString(undefined, options);
    firstSlide.addText(`As of ${currentDate}`, { 
      x: '-10%', y: '62%', w: '100%', fontSize: 22, bold: true, color: '0000FF', fontFace: 'Arial', align: 'center' 
    });

    // Slide 2: Total Utilization Summary for the Province
    const provinceUtilizationSlide = pptx.addSlide();
    provinceUtilizationSlide.background = { path: `${window.location.origin}/ppd-images/ppt-total.png` };

    // Add "TOTAL FUND UTILIZED" for the province
    const totalFundUtilizedPerProvince = province.total_utilization || 0;
    provinceUtilizationSlide.addText(`TOTAL FUND UTILIZED FOR ${province.col_province.toUpperCase()}`, { 
      x: '-5%', y: '42%', w: '90%', fontSize: 23, bold: true, color: '00072D', fontFace: 'Arial', align: 'center' 
    });

    // Display total fund utilized for the province
    provinceUtilizationSlide.addText(`₱${totalFundUtilizedPerProvince.toLocaleString()}`, { 
      x: '-10%', y: '52%', w: '90%', fontSize: 50, bold: true, color: '0000FF', fontFace: 'Arial', align: 'center'
    });

    // Iterate over districts and cities
    Object.values(province.districts || {}).forEach(district => {
      district.cities.forEach(city => {
        // Filter city data based on selectedYear and selectedQuarter
        const cityPrograms = city.programs.filter(program => {
          const createdAtDate = new Date(program.created_at); // Parse the created_at field
          const programYear = createdAtDate.getFullYear();
          const programQuarter = Math.ceil((createdAtDate.getMonth() + 1) / 3); // Calculate quarter from month
          return (selectedYear === 'all' || programYear === parseInt(selectedYear)) &&
                 (selectedQuarter === 'all' || programQuarter === parseInt(selectedQuarter));
        });

        // Slide 3: Physical Target and Fund Allocated for each city
        const cityTargetSlide = pptx.addSlide();
        cityTargetSlide.background = { path: `${window.location.origin}/ppd-images/ppt-table.png` };

        // Add city/municipality and province text
        cityTargetSlide.addText(`${city.col_citymuni.toUpperCase()}, ${province.col_province.toUpperCase()}`, {
          x: 0.5,
          y: 0.5,
          w: '70%',
          fontSize: 24,
          bold: true,
          color: '000991',
          fontFace: 'Arial',
          align: 'center',
        });

        // Add "SUMMARY PER PROGRAM" text
        cityTargetSlide.addText('SUMMARY PER PROGRAM', {
          x: 0.5,
          y: 1.0,
          w: '70%',
          fontSize: 20,
          bold: true,
          color: '000991',
          fontFace: 'Arial',
          align: 'center',
        });

        // Generate table for Physical Target and Fund Allocated
        const targetTableData = programs.map((program, index) => {
          const fillColor = index % 2 === 0 ? 'BDE0FE' : 'DDEFFA';
          const cityProgram = cityPrograms.find(p => p.program_id === program.program_id) || {};

          // Check and fetch data correctly for each city
          const target = cityProgram.total_target || 0;
          const allocated = cityProgram.total_allocation || 0;

          return [
            { text: program.program_name, options: { fontSize: 10, bold: true, align: 'center', fontFace: 'Arial', fill: fillColor } },
            { text: target.toString(), options: { fontSize: 10, align: 'center', fontFace: 'Arial', fill: fillColor } },
            { text: allocated.toLocaleString(), options: { fontSize: 10, align: 'center', fontFace: 'Arial', fill: fillColor } },
          ];
        });

        const totalTarget = city.total_target || 0;
        const totalAllocated = city.total_allocation || 0;

        const totalRowTarget = [
          { text: 'Total', options: { bold: true, fontSize: 10, align: 'center', fontFace: 'Arial', fill: 'FFD700' } },
          { text: totalTarget.toString(), options: { bold: true, fontSize: 10, align: 'center', fontFace: 'Arial', fill: 'FFD700' } },
          { text: totalAllocated.toLocaleString(), options: { bold: true, fontSize: 10, align: 'center', fontFace: 'Arial', fill: 'FFD700' } },
        ];

        const targetTableHeader = [
          { text: 'Program', options: { bold: true, fontSize: 12, align: 'center', color: 'FFFFFF', fill: '0070C0', fontFace: 'Arial' } },
          { text: 'Physical Target', options: { bold: true, fontSize: 12, align: 'center', color: 'FFFFFF', fill: '0070C0', fontFace: 'Arial' } },
          { text: 'Fund Allocated (Php)', options: { bold: true, fontSize: 12, align: 'center', color: 'FFFFFF', fill: '0070C0', fontFace: 'Arial' } },
        ];

        // Add the table to the slide
        cityTargetSlide.addTable([targetTableHeader, ...targetTableData, totalRowTarget], {
          x: 1.0,
          y: 1.5,
          w: 8,
          h: 3.5,
          colW: [2.5, 2, 2],
          border: { pt: 0.5, color: 'FFFFFF' },
          fontSize: 12,
          fontFace: 'Arial',
        });

        // Physical Served and Fund Utilized table for each city
        const totalServed = city.total_physical || 0;
        const totalUtilized = city.total_utilization || 0;

        const cityUtilizationSlide = pptx.addSlide();
        cityUtilizationSlide.background = { path: `${window.location.origin}/ppd-images/ppt-table.png` };

        cityUtilizationSlide.addText(`${city.col_citymuni.toUpperCase()}, ${province.col_province.toUpperCase()}`, {
          x: 0.5,
          y: 0.5,
          w: '70%',
          fontSize: 24,
          bold: true,
          color: '000991',
          fontFace: 'Arial',
          align: 'center',
        });

        cityUtilizationSlide.addText('SUMMARY PER PROGRAM', {
          x: 0.5,
          y: 1.0,
          w: '70%',
          fontSize: 20,
          bold: true,
          color: '000991',
          fontFace: 'Arial',
          align: 'center',
        });

        const utilizationTableData = programs.map((program, index) => {
          const fillColor = index % 2 === 0 ? 'BDE0FE' : 'DDEFFA';
          const cityProgram = cityPrograms.find(p => p.program_id === program.program_id) || {};
          const served = cityProgram.total_physical || 0;
          const utilized = cityProgram.total_utilization || 0;

          return [
            { text: program.program_name, options: { fontSize: 10, bold: true, align: 'center', fontFace: 'Arial', fill: fillColor } },
            { text: served.toString(), options: { fontSize: 10, align: 'center', fontFace: 'Arial', fill: fillColor } },
            { text: utilized.toLocaleString(), options: { fontSize: 10, align: 'center', fontFace: 'Arial', fill: fillColor } },
          ];
        });

        const totalRowUtilization = [
          { text: 'Total', options: { bold: true, fontSize: 10, align: 'center', fontFace: 'Arial', fill: 'FFD700' } },
          { text: totalServed.toString(), options: { bold: true, fontSize: 10, align: 'center', fontFace: 'Arial', fill: 'FFD700' } },
          { text: totalUtilized.toLocaleString(), options: { bold: true, fontSize: 10, align: 'center', fontFace: 'Arial', fill: 'FFD700' } },
        ];

        const utilizationTableHeader = [
          { text: 'Program', options: { bold: true, fontSize: 12, align: 'center', color: 'FFFFFF', fill: '0070C0', fontFace: 'Arial' } },
          { text: 'Physical Served', options: { bold: true, fontSize: 12, align: 'center', color: 'FFFFFF', fill: '0070C0', fontFace: 'Arial' } },
          { text: 'Fund Utilized (Php)', options: { bold: true, fontSize: 12, align: 'center', color: 'FFFFFF', fill: '0070C0', fontFace: 'Arial' } },
        ];

        cityUtilizationSlide.addTable([utilizationTableHeader, ...utilizationTableData, totalRowUtilization], {
          x: 1.0,
          y: 1.5,
          w: 8,
          h: 3.5,
          colW: [2.5, 2, 2],
          border: { pt: 0.5, color: 'FFFFFF' },
          fontSize: 12,
          fontFace: 'Arial',
        });
      });
    });

    // Last Slide: Summary of all Cities in the Province (Target and Allocation)
    const summarySlide1 = pptx.addSlide();
    summarySlide1.background = { path: `${window.location.origin}/ppd-images/ppt-table.png` };

    summarySlide1.addText('SUMMARY PER MUNICIPALITY', {
      x: 0.5,
      y: 0.5, w: '70%', fontSize: 24, bold: true, color: '000991', fontFace: 'Arial', align: 'center'
    });

    const summaryTableHeader1 = [
      [
        { text: `${province.col_province.toUpperCase()}`, options: { bold: true, fontSize: 12, align: 'center', color: 'FFFFFF', fill: '0070C0', fontFace: 'Arial', colspan: 1 } },
        { text: 'TARGET', options: { bold: true, fontSize: 12, align: 'center', color: 'FFFFFF', fill: '0070C0', fontFace: 'Arial', colspan: 2 } }
      ],
      [
        { text: 'Municipality', options: { bold: true, fontSize: 12, align: 'center', color: 'FFFFFF', fill: '0070C0', fontFace: 'Arial' } },
        { text: 'Physical', options: { bold: true, fontSize: 12, align: 'center', color: 'FFFFFF', fill: '0070C0', fontFace: 'Arial' } },
        { text: 'Fund Allocated (Php)', options: { bold: true, fontSize: 12, align: 'center', color: 'FFFFFF', fill: '0070C0', fontFace: 'Arial' } }
      ]
    ];

    const rows1 = [];
    let totalPhysicalTarget = 0;
    let totalFundAllocated = 0;

    Object.values(province.districts || {}).forEach(district => {
      if (district.district) {
        rows1.push([
          { text: `${getOrdinal(district.district)} Congressional District`, options: { bold: true, fontSize: 10, align: 'left', color: '0000FF', fontFace: 'Arial', colspan: 3 } }
        ]);
      }

      district.cities.forEach((city, index) => {
        const fillColor = index % 2 === 0 ? 'BDE0FE' : 'DDEFFA';
        const target = city.total_target || 0;
        const allocated = city.total_allocation || 0;

        totalPhysicalTarget += target;
        totalFundAllocated += allocated;

        rows1.push([
          { text: city.col_citymuni, options: { fontSize: 10, align: 'left', fontFace: 'Arial', fill: fillColor } },
          { text: target.toString(), options: { fontSize: 10, align: 'right', fontFace: 'Arial', fill: fillColor } },
          { text: allocated.toLocaleString(), options: { fontSize: 10, align: 'right', fontFace: 'Arial', fill: fillColor } }
        ]);
      });
    });

    rows1.push([
      { text: 'TOTAL', options: { bold: true, fontSize: 10, align: 'right', fontFace: 'Arial', fill: 'FFD700' } },
      { text: totalPhysicalTarget.toString(), options: { bold: true, fontSize: 10, align: 'right', fontFace: 'Arial', fill: 'FFD700' } },
      { text: totalFundAllocated.toLocaleString(), options: { bold: true, fontSize: 10, align: 'right', fontFace: 'Arial', fill: 'FFD700' } }
    ]);

    summarySlide1.addTable([...summaryTableHeader1, ...rows1], {
      x: 1.0,
      y: 1.0,
      w: 7,
      h: 3.5,
      colW: [2.5, 2, 2],
      rowH: 0.1,
      fontSize: 14,
      border: { pt: 1, color: 'FFFFFF' },
      fill: { color: 'FFFFFF' }
    });

    // Similar for utilization summary
    const summarySlide2 = pptx.addSlide();
    summarySlide2.background = { path: `${window.location.origin}/ppd-images/ppt-table.png` };

    summarySlide2.addText('SUMMARY PER MUNICIPALITY', {
      x: 0.5,
      y: 0.5, w: '70%', fontSize: 24, bold: true, color: '000991', fontFace: 'Arial', align: 'center'
    });

    const summaryTableHeader2 = [
      [
        { text: `${province.col_province.toUpperCase()}`, options: { bold: true, fontSize: 12, align: 'center', color: 'FFFFFF', fill: '0070C0', fontFace: 'Arial', colspan: 1 } },
        { text: 'SERVED', options: { bold: true, fontSize: 12, align: 'center', color: 'FFFFFF', fill: '0070C0', fontFace: 'Arial', colspan: 2 } }
      ],
      [
        { text: 'Municipality', options: { bold: true, fontSize: 12, align: 'center', color: 'FFFFFF', fill: '0070C0', fontFace: 'Arial' } },
        { text: 'Physical Served', options: { bold: true, fontSize: 12, align: 'center', color: 'FFFFFF', fill: '0070C0', fontFace: 'Arial' } },
        { text: 'Fund Utilized (Php)', options: { bold: true, fontSize: 12, align: 'center', color: 'FFFFFF', fill: '0070C0', fontFace: 'Arial' } }
      ]
    ];

    const rows2 = [];
    let totalPhysicalServed = 0;
    let totalFundUtilized = 0;

    Object.values(province.districts || {}).forEach(district => {
      if (district.district) {
        rows2.push([
          { text: `${getOrdinal(district.district)} Congressional District`, options: { bold: true, fontSize: 10, align: 'left', color: '0000FF', fontFace: 'Arial', colspan: 3 } }
        ]);
      }

      district.cities.forEach((city, index) => {
        const fillColor = index % 2 === 0 ? 'BDE0FE' : 'DDEFFA';
        const served = city.total_physical || 0;
        const utilized = city.total_utilization || 0;

        totalPhysicalServed += served;
        totalFundUtilized += utilized;

        rows2.push([
          { text: city.col_citymuni, options: { fontSize: 10, align: 'left', fontFace: 'Arial', fill: fillColor } },
          { text: served.toString(), options: { fontSize: 10, align: 'right', fontFace: 'Arial', fill: fillColor } },
          { text: utilized.toLocaleString(), options: { fontSize: 10, align: 'right', fontFace: 'Arial', fill: fillColor } }
        ]);
      });
    });

    rows2.push([
      { text: 'TOTAL', options: { bold: true, fontSize: 10, align: 'right', fontFace: 'Arial', fill: 'FFD700' } },
      { text: totalPhysicalServed.toString(), options: { bold: true, fontSize: 10, align: 'right', fontFace: 'Arial', fill: 'FFD700' } },
      { text: totalFundUtilized.toLocaleString(), options: { bold: true, fontSize: 10, align: 'right', fontFace: 'Arial', fill: 'FFD700' } }
    ]);

    summarySlide2.addTable([...summaryTableHeader2, ...rows2], {
      x: 1.0,
      y: 1.0,
      w: 7,
      h: 3.5,
      colW: [2.5, 2, 2],
      rowH: 0.1,
      fontSize: 14,
      border: { pt: 1, color: 'FFFFFF' },
      fill: { color: 'FFFFFF' }
    });
  });

  // Save the PowerPoint file with the province name in the file name
  const fileName = `${provinceName}_Brief_Report_By_Area.pptx`;
  pptx.writeFile({ fileName });
};
