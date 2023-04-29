import React, { useState } from "react";
import NavB from "./Navbar";
import { pb } from "./login_page/Login";
import Footer from "./Footer";
import "./App.css"
import { useNavigate } from "react-router";
import Loader from "./helper/Loader";
import VisibilityIcon from '@mui/icons-material/Visibility';
import UpdateIcon from '@mui/icons-material/Update';
import NoteAddIcon from '@mui/icons-material/NoteAdd';
import PrintIcon from '@mui/icons-material/Print';

function Home() {
  const navigate = useNavigate();
  const [loading, setLoading] = useState(false);
  
  const delay = ms => new Promise(
    resolve => setTimeout(resolve, ms)
  );


  async function navigateToStudents() {
    setLoading(true);
    await delay(1000);
    navigate('/view');
    setLoading(false);
  };

  async function navigateToUpdate() {
    setLoading(true);
    await delay(1000);
    navigate('/update');
    setLoading(false);
  };

  async function navigateToUpload() {
    setLoading(true);
    await delay(1000);
    navigate('/upload');
    setLoading(false);
  };

  async function navigateToPrint() {
    setLoading(true);
    await delay(1000);
    navigate('/download');
    setLoading(false);
  };

  async function navigateToQR() {
    setLoading(true);
    await delay(1000);
    navigate('/qrgen8r');
    setLoading(false);
  };


  if (pb.authStore.isValid) {
    return (
      loading ? <Loader /> :
        <div className="main">
          <NavB />
          <div className="head-container">
            <h2 className="heading">Hello Admin! What would you like to do:</h2>
            <div className="btn-box">
            <button className="home-btn btn btn-primary" onClick={navigateToStudents}><VisibilityIcon style={{marginBottom:"3px", marginRight: "5px"}}/>VIEW ATTENDANCE</button>
            <button className="home-btn btn btn-primary" onClick={navigateToUpdate}><UpdateIcon style={{marginBottom:"3px", marginRight: "5px"}}/>UPDATE ATTENDANCE</button>
            <button className="home-btn btn btn-primary" onClick={navigateToUpload}><NoteAddIcon style={{marginBottom:"3px", marginRight: "5px"}}/>ADD ATTENDANCE SHEET</button>
            <button className="home-btn btn btn-primary" onClick={navigateToPrint}><PrintIcon style={{marginBottom:"3px", marginRight: "5px"}}/>PRINT ATTENDANCE LIST</button>
            <button className="home-btn btn btn-primary" onClick={navigateToQR}><PrintIcon style={{marginBottom:"3px", marginRight: "5px"}}/>QR ATTENDANCE</button>
            </div>
          </div>
          <div className="footer">
            <Footer />
          </div>
        </div>
    );
  }
  else {
    window.location.href = "/login"
  }
}

export default Home;