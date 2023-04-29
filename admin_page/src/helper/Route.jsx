import React from "react";
import { Route, Routes, useLocation } from 'react-router-dom';
import Login from "../login_page/Login";
import Home from "../Home";
import Students from "../Students";
import Update from "../updation/Update";
import Upload from "../upload/Upload";
import Download from "../print/Download";
import InitialTransition from "../login_page/Loading";

function PageRoute() {
    const location = useLocation();
    return (
        <Routes location={location} key={location.pathname}>
            <Route path="/loading" element={<InitialTransition/>} />
            <Route path="/" element={<Login />}/>
            <Route path="/login" element={<Login />}/>
            <Route path="/home" element={<Home />}/>
            <Route path="/view" element={<Students />}/>
            <Route path="/update" element={<Update />}/>
            <Route path="/upload" element={<Upload />}/>
            <Route path="/download" element={<Download />}/>
        </Routes>
    )
}

export default PageRoute