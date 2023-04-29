import React from 'react';
import { MDBFooter, MDBContainer, MDBRow, MDBCol, MDBIcon } from 'mdb-react-ui-kit';
import "./App.css"

function Footer() {
  return (
    <MDBFooter className='foot text-center text-lg-start text-muted'>
      <section className=''>
        <MDBContainer className='text-center text-md-start mt-5'>
          <MDBRow className='mt-4'>
            <MDBCol md='4' lg='3' xl='3' className='mx-auto mb-md-0 mb-0 mt-3'>
              <h6 className='text-uppercase fw-bold mb-4'>Contact</h6>
              <p>
                <MDBIcon color='secondary' icon='university' className='me-3' />
                Sardar Patel Institute of Technology
              </p>
              <p>
                <MDBIcon color='secondary' icon='envelope' className='me-3' />
                info@example.com
              </p>
              <p>
                <MDBIcon color='secondary' icon='phone' className='me-2' /> + 91 69234 56788
              </p>
            </MDBCol>
          </MDBRow>
        </MDBContainer>
      </section>

      <div className='text-center p-4' style={{ backgroundColor: 'rgba(0, 0, 0, 0.05)' }}>
        © 2023 Copyright: AttendEase
      </div>
    </MDBFooter>
  );
}

export default Footer;