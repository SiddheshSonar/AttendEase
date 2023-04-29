import React from 'react';
import ReactLoading from "react-loading"
import NavB from '../Navbar';

const Loader = () => {
    return (
        <div>
            <NavB/>
            <ReactLoading className='load-btn' type="spin" color="#0000FF"
                height={100} width={50} />
        </div>
    );
};

export default Loader;