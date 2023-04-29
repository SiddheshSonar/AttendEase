import React, { useState } from 'react';
import NavB from '../Navbar';

const Upload = () => {
    const [file, setFile] = useState(null);

    function handleFile(event) {
        setFile(event.target.files[0]);
    }

    function handleUpload() {
        setLoading(true);
        const formData = new FormData();
        formData.append('file', file);
        fetch('http://localhost:5000/upload', {
            method: 'POST',
            body: formData
        })
            .then(response => response.json())
            .then(data => console.log(data))
            .catch(error => console.error(error))
            .finally(() => {
                setLoading(false);
            });
    }

    return (
        <div>
            <NavB/>
            <div className='upload-container'>
            <input className="" type="file" onChange={handleFile} />
            <button className="btn btn-primary" onClick={handleUpload}>UPLOAD FILE</button>
            </div>
        </div>
    );
};

export default Upload;