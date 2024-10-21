import PptxGenJS from 'pptxgenjs';

// Function to convert district number to ordinal (1st, 2nd, 3rd, etc.)
const getOrdinal = (number) => {
  if (number === 1) return '1st'; 
  if (number === 2) return '2nd';
  if (number === 3) return '3rd';
  return `${number}th`; // For any other number (4th, 5th, etc.)
};

// Function to format and generate PowerPoint report
export const generateProgramPpt = (provinces, programs, cities, provinceName, selectedYear, selectedQuarter) => {
  const pptx = new PptxGenJS();

  provinces.forEach(province => {
    // Slide 1: Province Overview
    const firstSlide = pptx.addSlide();
    firstSlide.background = { path: `${window.location.origin}/ppd-images/ppt-bg.png` };
    
    firstSlide.addText(province.col_province.toUpperCase(), { 
      x: '-10%', y: '42%', w: '100%', fontSize: 44, bold: true, color: '00072D', fontFace: 'Arial', align: 'center' 
    });
    firstSlide.addText('TARGET AND ACCOMPLISHMENT', { 
      x: '-10%', y: '52%', w: '100%', fontSize: 28, bold: true, color: '00072D', fontFace: 'Arial', align: 'center' 
    });

    const options = { year: 'numeric', month: 'long', day: 'numeric' };
    const currentDate = new Date().toLocaleDateString(undefined, options);
    firstSlide.addText(`As of ${currentDate}`, { 
      x: '-10%', y: '62%', w: '100%', fontSize: 22, bold: true, color: '0000FF', fontFace: 'Arial', align: 'center' 
    });

    // Slide 2: Total Utilization Summary for the Province
    const provinceUtilizationSlide = pptx.addSlide();
    provinceUtilizationSlide.background = { path: `${window.location.origin}/ppd-images/ppt-total.png` };

    let totalFundUtilizedPerProvince = 0;
    Object.values(province.districts || {}).forEach(district => {
      district.cities.forEach(city => {
        const utilized = city.total_utilization || 0;
        totalFundUtilizedPerProvince += utilized;
      });
    });

    provinceUtilizationSlide.addText(`TOTAL FUND UTILIZED FOR ${province.col_province.toUpperCase()}`, { 
      x: '-5%', y: '42%', w: '90%', fontSize: 23, bold: true, color: '00072D', fontFace: 'Arial', align: 'center' 
    });

    provinceUtilizationSlide.addText(`₱${totalFundUtilizedPerProvince.toLocaleString()}`, { 
      x: '-10%', y: '52%', w: '90%', fontSize: 50, bold: true, color: '0000FF', fontFace: 'Arial', align: 'center'
    });

    // Initialize arrays to store total allocations, utilizations, targets, and physical amounts per program
    const programAllocations = {};
    const programUtilizations = {};
    const programTargets = {};
    const programPhysical = {};

    programs.forEach(program => {
      // Slide for Allocation Summary for the Program
      const allocationSlide = pptx.addSlide();
      allocationSlide.background = { path: `${window.location.origin}/ppd-images/ppt-table.png` };

      allocationSlide.addText(`${program.program_name}`, {
        x: 0.5,
        y: 0.5, w: '70%', fontSize: 24, bold: true, color: '000991', fontFace: 'Arial', align: 'center'
      });

      allocationSlide.addImage({
        path: `${window.location.origin}/${program.program_logo}`,
        x: 0, y: 0, w: 1.0, h: 1.0
      });

      const allocationTableHeader = [
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

      const allocationRows = [];
      let totalPhysicalTarget = 0;
      let totalFundAllocated = 0;

      Object.values(province.districts || {}).forEach(district => {
        if (district.district) {
          allocationRows.push([
            { text: `${getOrdinal(district.district)} Congressional District`, options: { bold: true, fontSize: 10, align: 'left', color: '0000FF', fontFace: 'Arial', colspan: 3 } }
          ]);
        }

        district.cities.forEach((city, index) => {
          // Ensure the city appears even if there is no data for this program
          const programData = city.programs?.find(prog => prog.program_name === program.program_name) || {
            total_target: 0,
            total_allocation: 0,
            
          };

          const fillColor = index % 2 === 0 ? 'BDE0FE' : 'DDEFFA';
          const target = parseInt(programData.total_target || 0, 10);  // Ensure integer for physical target
          const allocated = parseFloat(programData.total_allocation || 0); // Fund allocated with decimals
          

          totalPhysicalTarget += target;
          totalFundAllocated += allocated;

          // Update the totals for this program
          programAllocations[program.program_name] = (programAllocations[program.program_name] || 0) + allocated;
          programTargets[program.program_name] = (programTargets[program.program_name] || 0) + target;
          

          allocationRows.push([
            { text: city.col_citymuni, options: { fontSize: 10, align: 'left', fontFace: 'Arial', fill: fillColor } },
            { text: target.toLocaleString(), options: { fontSize: 10, align: 'right', fontFace: 'Arial', fill: fillColor } }, // Integer display
            { text: allocated.toLocaleString(undefined, { minimumFractionDigits: 2 }), options: { fontSize: 10, align: 'right', fontFace: 'Arial', fill: fillColor } } // Decimal display
          ]);
        });
      });

      allocationRows.push([
        { text: 'TOTAL', options: { bold: true, fontSize: 10, align: 'right', fontFace: 'Arial', fill: 'FFD700' } },
        { text: totalPhysicalTarget.toLocaleString(), options: { bold: true, fontSize: 10, align: 'right', fontFace: 'Arial', fill: 'FFD700' } }, // Integer display
        { text: totalFundAllocated.toLocaleString(undefined, { minimumFractionDigits: 2 }), options: { bold: true, fontSize: 10, align: 'right', fontFace: 'Arial', fill: 'FFD700' } } // Decimal display
      ]);

      allocationSlide.addTable([...allocationTableHeader, ...allocationRows], {
        x: 1.0,
        y: 1.0,
        w: 7,
        h: 3.5,
        colW: [2.5, 2, 2],
        rowH: 0.2,
        fontSize: 14,
        border: { pt: 1, color: 'FFFFFF' },
        fill: { color: 'FFFFFF' }
      });

      // Slide for Utilization Summary for the Program
      const utilizationSlide = pptx.addSlide();
      utilizationSlide.background = { path: `${window.location.origin}/ppd-images/ppt-table.png` };

      utilizationSlide.addText(`${program.program_name}`, {
        x: 0.5,
        y: 0.5, w: '70%', fontSize: 24, bold: true, color: '000991', fontFace: 'Arial', align: 'center'
      });

      utilizationSlide.addImage({
        path: `${window.location.origin}/${program.program_logo}`,
        x: 0, y: 0, w: 1.0, h: 1.0
      });

      const utilizationTableHeader = [
        [
          { text: `${province.col_province.toUpperCase()}`, options: { bold: true, fontSize: 12, align: 'center', color: 'FFFFFF', fill: '0070C0', fontFace: 'Arial', colspan: 1 } },
          { text: 'ACCOMPLISHMENT', options: { bold: true, fontSize: 12, align: 'center', color: 'FFFFFF', fill: '0070C0', fontFace: 'Arial', colspan: 2 } }
        ],
        [
          { text: 'Municipality', options: { bold: true, fontSize: 12, align: 'center', color: 'FFFFFF', fill: '0070C0', fontFace: 'Arial' } },
          { text: 'Physical', options: { bold: true, fontSize: 12, align: 'center', color: 'FFFFFF', fill: '0070C0', fontFace: 'Arial' } },
          { text: 'Fund Utilized (Php)', options: { bold: true, fontSize: 12, align: 'center', color: 'FFFFFF', fill: '0070C0', fontFace: 'Arial' } }
        ]
      ];

      const utilizationRows = [];
      let totalFundUtilized = 0;
      let totalPhysical = 0;

      Object.values(province.districts || {}).forEach(district => {
        if (district.district) {
          utilizationRows.push([
            { text: `${getOrdinal(district.district)} Congressional District`, options: { bold: true, fontSize: 10, align: 'left', color: '0000FF', fontFace: 'Arial', colspan: 3 } }
          ]);
        }

        district.cities.forEach((city, index) => {
          // Ensure the city appears even if there is no data for this program
          const programData = city.programs?.find(prog => prog.program_name === program.program_name) || {
            total_utilization: 0,
            total_physical: 0
          };

          const fillColor = index % 2 === 0 ? 'BDE0FE' : 'DDEFFA';
          const utilized = parseFloat(programData.total_utilization || 0); // Fund utilized with decimals
          const physical = parseInt(programData.total_physical || 0, 10);  // Ensure integer for physical served

          totalFundUtilized += utilized;
          totalPhysical += physical;

          programUtilizations[program.program_name] = (programUtilizations[program.program_name] || 0) + utilized;
          programPhysical[program.program_name] = (programPhysical[program.program_name] || 0) + physical;

          utilizationRows.push([
            { text: city.col_citymuni, options: { fontSize: 10, align: 'left', fontFace: 'Arial', fill: fillColor } },
            { text: physical.toLocaleString(), options: { fontSize: 10, align: 'right', fontFace: 'Arial', fill: fillColor } }, // Integer display
            { text: utilized.toLocaleString(undefined, { minimumFractionDigits: 2 }), options: { fontSize: 10, align: 'right', fontFace: 'Arial', fill: fillColor } } // Decimal display
          ]);
        });
      });

      utilizationRows.push([
        { text: 'TOTAL', options: { bold: true, fontSize: 10, align: 'right', fontFace: 'Arial', fill: 'FFD700' } },
        { text: totalPhysical.toLocaleString(), options: { bold: true, fontSize: 10, align: 'right', fontFace: 'Arial', fill: 'FFD700' } }, // Integer display
        { text: totalFundUtilized.toLocaleString(undefined, { minimumFractionDigits: 2 }), options: { bold: true, fontSize: 10, align: 'right', fontFace: 'Arial', fill: 'FFD700' } } // Decimal display
      ]);

      utilizationSlide.addTable([...utilizationTableHeader, ...utilizationRows], {
        x: 1.0,
        y: 1.0,
        w: 7,
        h: 3.5,
        colW: [2.5, 2, 2],
        rowH: 0.2,
        fontSize: 14,
        border: { pt: 1, color: 'FFFFFF' },
        fill: { color: 'FFFFFF' }
      });
    });

    // Allocation Overview Slide (Summary Slide)
    const allocationOverviewSlide = pptx.addSlide();
    allocationOverviewSlide.background = { path: `${window.location.origin}/ppd-images/ppt-table.png` };

    allocationOverviewSlide.addText('SUMMARY PER PROGRAM', {
      x: 0.5, y: 0.5, fontSize: 24, bold: true, color: '000991', fontFace: 'Arial', align: 'center'
    });

    const allocationOverviewHeader = [
      { text: 'Program', options: { bold: true, fontSize: 12, align: 'center', color: 'FFFFFF', fill: '0070C0', fontFace: 'Arial' } },
      { text: 'Physical Target', options: { bold: true, fontSize: 12, align: 'center', color: 'FFFFFF', fill: '0070C0', fontFace: 'Arial' } },
      { text: 'Fund Allocated (Php)', options: { bold: true, fontSize: 12, align: 'center', color: 'FFFFFF', fill: '0070C0', fontFace: 'Arial' } }
    ];

    const allocationOverviewRows = Object.keys(programAllocations).map((programName, index) => {
      const fillColor = index % 2 === 0 ? 'BDE0FE' : 'DDEFFA';
      return [
        { text: programName, options: { fontSize: 10, align: 'left', fontFace: 'Arial', fill: fillColor } },
        { text: programTargets[programName].toLocaleString(), options: { fontSize: 10, align: 'center', fontFace: 'Arial', fill: fillColor } }, // Integer display
        { text: programAllocations[programName].toLocaleString(undefined, { minimumFractionDigits: 2 }), options: { fontSize: 10, align: 'center', fontFace: 'Arial', fill: fillColor } } // Decimal display
      ];
    });

    const totalTarget = Object.values(programTargets).reduce((sum, value) => sum + value, 0);
    const totalAllocated = Object.values(programAllocations).reduce((sum, value) => sum + value, 0);
    const totalRow = [
      { text: 'TOTAL', options: { bold: true, fontSize: 10, align: 'center', fontFace: 'Arial', fill: 'FFD700' } },
      { text: totalTarget.toLocaleString(), options: { bold: true, fontSize: 10, align: 'center', fontFace: 'Arial', fill: 'FFD700' } }, // Integer display
      { text: totalAllocated.toLocaleString(undefined, { minimumFractionDigits: 2 }), options: { bold: true, fontSize: 10, align: 'center', fontFace: 'Arial', fill: 'FFD700' } } // Decimal display
    ];

    allocationOverviewSlide.addTable([allocationOverviewHeader, ...allocationOverviewRows, totalRow], {
      x: 1.0,
      y: 1.0,
      w: 8,
      h: 3.5,
      colW: [2.5, 2, 2], border: { pt: 0.5, color: 'FFFFFF' }, fontSize: 12, fontFace: 'Arial'
    });

   // Utilization Overview Slide (Summary Slide)
const utilizationOverviewSlide = pptx.addSlide();
utilizationOverviewSlide.background = { path: `${window.location.origin}/ppd-images/ppt-table.png` };

utilizationOverviewSlide.addText('SUMMARY PER PROGRAM', {
  x: 0.5, y: 0.5, fontSize: 24, bold: true, color: '000991', fontFace: 'Arial', align: 'center'
});

const utilizationOverviewHeader = [
  { text: 'Program', options: { bold: true, fontSize: 12, align: 'center', color: 'FFFFFF', fill: '0070C0', fontFace: 'Arial' } },
  { text: 'Physical Served', options: { bold: true, fontSize: 12, align: 'center', color: 'FFFFFF', fill: '0070C0', fontFace: 'Arial' } },
  { text: 'Fund Utilized (Php)', options: { bold: true, fontSize: 12, align: 'center', color: 'FFFFFF', fill: '0070C0', fontFace: 'Arial' } }
];

const utilizationOverviewRows = Object.keys(programUtilizations).map((programName, index) => {
  const fillColor = index % 2 === 0 ? 'BDE0FE' : 'DDEFFA';

  // Ensure the physical served and fund utilized are summed correctly and reset for each program
  const programPhysicalServed = programPhysical[programName] || 0;  // Ensure the default is 0 if undefined
  const programFundUtilized = programUtilizations[programName] || 0;

  // Debugging to track if values are being doubled
  console.log(`Program: ${programName}, Physical Served: ${programPhysicalServed}, Fund Utilized: ${programFundUtilized}`);

  return [
    { text: programName, options: { fontSize: 10, align: 'left', fontFace: 'Arial', fill: fillColor } },
    { text: programPhysicalServed.toLocaleString(), options: { fontSize: 10, align: 'center', fontFace: 'Arial', fill: fillColor } }, // Integer display
    { text: programFundUtilized.toLocaleString(undefined, { minimumFractionDigits: 2 }), options: { fontSize: 10, align: 'center', fontFace: 'Arial', fill: fillColor } } // Decimal display
  ];
});

// Calculate the total physical served and total fund utilized for the summary row
const totalPhysicalServed = Object.values(programPhysical).reduce((sum, value) => sum + value, 0);
const totalFundUtilized = Object.values(programUtilizations).reduce((sum, value) => sum + value, 0);

const totalUtilizationRow = [
  { text: 'TOTAL', options: { bold: true, fontSize: 10, align: 'center', fontFace: 'Arial', fill: 'FFD700' } },
  { text: totalPhysicalServed.toLocaleString(), options: { bold: true, fontSize: 10, align: 'center', fontFace: 'Arial', fill: 'FFD700' } }, // Integer display
  { text: totalFundUtilized.toLocaleString(undefined, { minimumFractionDigits: 2 }), options: { bold: true, fontSize: 10, align: 'center', fontFace: 'Arial', fill: 'FFD700' } } // Decimal display
];

utilizationOverviewSlide.addTable([utilizationOverviewHeader, ...utilizationOverviewRows, totalUtilizationRow], {
  x: 1.0,
  y: 1.0,
  w: 8,
  h: 3.5,
  colW: [2.5, 2, 2], 
  border: { pt: 0.5, color: 'FFFFFF' }, 
  fontSize: 12, 
  fontFace: 'Arial'
});
  });

  const fileName = `${provinceName}_Brief_Report_By PPAs}.pptx`;
  pptx.writeFile({ fileName });
};
