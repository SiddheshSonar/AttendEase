import React, { useState } from "react";
import NavB from "../Navbar";

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
    fetch("http://localhost:5000/upload", {
      method: "POST",
      body: formData,
    })
      .then((response) => response.json())
      .then((data) => {
        setUploadStatus(data.message);
        console.log(data);
      })
      .catch((error) => console.error(error))
      .finally(() => {
        // setLoading(false);
      });
  }

  return (
    <div className="up-main">
      <NavB />
      <div className="up-box">
      <h1 className="upload-title">Upload Your File</h1>
      <div className="upload-container">
        <div
          className="dropzone"
          onDragOver={(event) => event.preventDefault()}
          onDrop={handleDrop}
        >
          {file ? (
            <p className="title-font">{file.name}</p>
          ) : (
            <p>Drag and drop a file here or click to select a file.</p>
          )}
        </div>
        <input type="file" onChange={handleFile} accept=".csv" style={{ display: "none" }} />
        <button
          className="up-btn btn btn-primary"
          onClick={() => document.querySelector('input[type="file"]').click()}
        >
          SELECT FILE
        </button>
        <button
          className="up-btn btn btn-primary"
          disabled={!file}
          onClick={handleUpload}
        >
          UPLOAD FILE
        </button>
        {uploadStatus && <p>{uploadStatus}</p>}
      </div>
      </div>
    </div>
  );
};

export default Upload;
