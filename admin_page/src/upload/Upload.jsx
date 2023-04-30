import React, { useState } from "react";
import NavB from "../Navbar";
import FolderIcon from '@mui/icons-material/Folder';
import FileUploadIcon from '@mui/icons-material/FileUpload';
import UploadFileIcon from '@mui/icons-material/UploadFile';
import AttachFileIcon from '@mui/icons-material/AttachFile';

const Upload = () => {
  const [file, setFile] = useState(null);
  const [uploadStatus, setUploadStatus] = useState(null);

  function handleFile(event) {
    setFile(event.target.files[0]);
  }

  function handleDrop(event) {
    event.preventDefault();
    const droppedFile = event.dataTransfer.files[0];
    setFile(droppedFile);
  }

  function handleUpload() {
    // setLoading(true);
    const formData = new FormData();
    formData.append("file", file);
    fetch("http://localhost:3000/upload", {
      method: "POST",
      body: formData,
    })
      .then((response) => response.json())
      .then((data) => {
        setUploadStatus(data.message);
        console.log(data);
        window.alert("File submitted successfully!");
      })
      .catch((error) => {console.error(error)
        window.alert("File submitted successfully!");})
      .finally(() => {
        // setLoading(false);
      });
  }

  return (
    <div className="up-main">
      <NavB />
      <div className="up-box">
      <h1 className="upload-title"><UploadFileIcon style={{fontSize:"38px",marginBottom:"6px",marginRight:"3px"}}/>Upload Your File</h1>
      <div className="upload-container">
        <div
          className="dropzone"
          onDragOver={(event) => event.preventDefault()}
          onDrop={handleDrop}
        >
          {file ? (
            <p className="title-font">{file.name}</p>
          ) : (
            <p><AttachFileIcon style={{marginBottom: "3px"}}/>Drag and drop a file here or click to select a file.</p>
          )}
        </div>
        <div className="up-btn-holder">
        <input type="file" onChange={handleFile} accept=".csv" style={{ display: "none" }} />
        <button
          className="up-btn btn btn-primary"
          onClick={() => document.querySelector('input[type="file"]').click()}
        ><FolderIcon style={{marginRight:"4px",marginBottom:"3px"}}/>
          SELECT FILE
        </button>
        <button
          className="up-btn btn btn-primary"
          disabled={!file}
          onClick={handleUpload}
        ><FileUploadIcon style={{marginRight:"4px",marginBottom:"3px"}}/>
          UPLOAD FILE
        </button>
        {uploadStatus && <p>{uploadStatus}</p>}
        </div>
      </div>
      </div>
    </div>
  );
};

export default Upload;
