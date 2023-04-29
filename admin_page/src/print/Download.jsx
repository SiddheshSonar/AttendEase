import React, { useState, useEffect } from 'react';
import NavB from '../Navbar';
import PrintTable from '../table/PrintTable';
import { pb } from '../login_page/Login';
import SchoolIcon from '@mui/icons-material/School';

const Download = () => {
  const [student, setStudent] = useState({});
  const [div, setDiv] = useState('');
  const divison = ['A', 'B', 'C', 'D', 'E', 'F'];

  useEffect(() => {
    async function fetchData() {
      try {
        const students = await pb.collection('students').getFullList({});
        setStudent(students);
      } catch (error) {
        console.log(error);
      }
    }
    fetchData();
  }, []);

  const handleDivisionClick = (selectedDivision) => {
    setDiv(selectedDivision);
  };

  return (
    <div>
      <NavB />
      <div className='pt-container'>
        <h2 className='pt-title'>Select Division</h2>
        <div className='pt-btn-box'>
          {divison.map((div) => (
            <button
              key={div}
              className='pt-btn btn btn-primary'
              onClick={() => handleDivisionClick(div)}
            >
              <SchoolIcon style={{marginRight:"5px",marginBottom:"4px"}}/>{`DIVISON ${div}`}
            </button>
          ))}
        </div>
        {div && (
          <>
            <PrintTable className='pt-table' divison={div} />
          </>
        )}
      </div>
    </div>
  );
};

export default Download;
