import React, { useState, useEffect } from "react";
import Table from "react-bootstrap/Table";
import "../App.css";
import { pb } from "../login_page/Login";
import UpPage from "../updation/UpPage";

const StudTable = () => {
  const [isLoading, setIsLoading] = useState(true);
  const [records, setRecords] = useState([]);
  const [courses, setCourses] = useState(null);
  const [selectedRecord, setSelectedRecord] = useState(null);
  const [searchInput, setSearchInput] = useState("");
  const [operation, setOperation] = useState("");

  useEffect(() => {
    async function fetchData() {
      const response = await pb.collection("students").getFullList({});
      setRecords(response);
      const course = await pb.collection("courses").getFullList({});
      setCourses(course)
      setIsLoading(false);
    }
    fetchData();
  }, []);

  const handleChange = (e) => {
    e.preventDefault();
    setSearchInput(e.target.value);
  };

  const filteredRecords = records.filter((record) => {
    return record.uid.toString().includes(searchInput);
  });

  const handleButtonClick = (record,opt) => {
    setSelectedRecord(record)
    setOperation(opt)
  }

  return (
    <div>
      {!isLoading && (
        <div className="spage">
          <div className="chart">
            {selectedRecord && <UpPage op={operation} record={selectedRecord} course={courses}/>}
          </div>
          <div className="search-table">
            <h2 className="table-head">Search Students By UID</h2>
            <input
              className="search-bar"
              type="text"
              placeholder="Enter UID"
              onChange={handleChange}
              value={searchInput}
            />
          <div className="table">
            <Table bordered style={{ backgroundColor: '#141e30'}}>
              <thead>
                <tr>
                  <th>UID</th>
                  <th>Name</th>
                  <th>Division</th>
                  <th className="atbt">Attendance</th>
                </tr>
              </thead>
              <tbody>
                {filteredRecords.map((record) => (
                  <tr key={record.uid} className="table-row">
                    <td>{record.uid}</td>
                    <td>{record.name}</td>
                    <td>{record.division}</td>
                    <td className="atbt">
                      <button
                        onClick={() => handleButtonClick(record,"CONFIRM ADDITION")}
                        className="btn btn-primary"
                      >
                        ADD
                      </button>
                      <button
                        onClick={() => handleButtonClick(record,"CONFIRM DELETION")}
                        className="btn btn-primary"
                      >
                        DELETE
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </Table>
          </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default StudTable;
