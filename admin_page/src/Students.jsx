import React from 'react';
import NavB from './Navbar';
import StudTable from './table/Table';

const Students = () => {

    return (
        <div className='studp'>
            <NavB />
            <div className='cont'>
                <StudTable />
            </div>
        </div>
    );
};

export default Students;