import React, { useState } from "react";
import NavB from "./Navbar";
import { pb } from "./login_page/Login";
import Footer from "./Footer";
import "./App.css"
import { useNavigate } from "react-router";
import Loader from "./helper/Loader";

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


  if (pb.authStore.isValid) {
    return (
      loading ? <Loader /> :
        <div className="main">
          <NavB />
          <div className="head-container">
            <h2 className="heading">Hello Admin! What would you like to do:</h2>
            <button className="btn btn-primary" onClick={navigateToStudents}>VIEW ATTENDANCE</button>
            <button className="btn btn-primary" onClick={navigateToUpdate}>UPDATE ATTENDANCE</button>
            <button className="btn btn-primary" onClick={navigateToUpload}>ADD ATTENDANCE SHEET</button>
            <button className="btn btn-primary" onClick={navigateToPrint}>PRINT ATTENDANCE LIST</button>
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