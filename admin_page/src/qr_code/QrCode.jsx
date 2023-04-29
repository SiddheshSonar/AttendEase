import React, { useState, useEffect } from "react";
import { QRCodeCanvas } from "qrcode.react";
import NavB from "../Navbar";
//import { randomInt } from "crypto";

const QrCode = () => {
    const [url, setUrl] = useState("");
    const [courses, setCourses] = useState(null);
    useEffect(() => {
        const interval = setInterval(() => {
            // Generate a random string of length 8 using letters and digits
            var randStr = Math.random().toString(36).substring(2, 10);
            var newUrl = `${url}:${randStr}`;
            if (newUrl.length > 40) {
                newUrl = newUrl.split(":")[0];
            }
            setUrl(newUrl); // update the url state
        }, 15000); // update the url state every 15 seconds
        return () => clearInterval(interval);
    }, [url]); // run every time the url state changes
    // sent data to backend
    useEffect(() => {
        console.log(url);
        fetch("http://localhost:3000/qr/"+url)
            .then((res) => res.json())
        },[url]);

    const qrCodeEncoder = (e) => {
        const newUrl = e.target.value;
        setUrl(newUrl);
    };

    return (
        <div  className="up-box">
            <NavB />
            <h1 className="scan-title" style={{ margin:"0px"  }}>Scan the QR for Attendance</h1>
        <div className="qrcode__container" align="center" style={{ padding: "1vmax", backgroundColor:"white" }}>
                <QRCodeCanvas
                    id="qrCode"
                    value={url}
                    size={400}
                    bgColor={"#FFFFFF"}
                    level={"H"}
                />
                <div className="input__group" style={{ padding: "2.5vmax", borderWidth:"0px", borderRadius:"3vmax"}}>
                    <input
                    style={{borderWidth:"0px", borderRadius:"0.7vmax"}}
                        type="text"
                        value={url}
                        onChange={qrCodeEncoder}
                        placeholder="add subject here"
                    />
                </div>
            </div>
        </div>
    );
};

export default QrCode;
