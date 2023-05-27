import React from 'react';
import { MDBFooter, MDBContainer, MDBRow, MDBCol, MDBIcon } from 'mdb-react-ui-kit';
import "./App.css"

function Footer() {
  return (
    <div className="custFooter">
    <MDBFooter className='text-center text-lg-left'>
      <div className='text-center p-3' style={{ backgroundColor: '#141e30', color: "#FFFFFF" }}>
        &copy; {new Date().getFullYear()} Copyright:{' '}AttendEase
      </div>
    </MDBFooter>
    </div>
  );
}

export default Footer;