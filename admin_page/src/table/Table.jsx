import React, { useState, useEffect } from "react";
import Table from "react-bootstrap/Table";
import Chart from "../chart/Chart";
import "../App.css";
import { pb } from "../login_page/Login";

const StudTable = () => {
  const [isLoading, setIsLoading] = useState(true);
  const [records, setRecords] = useState([]);
  const [selectedRecord, setSelectedRecord] = useState(null);
  const [searchInput, setSearchInput] = useState("");

  useEffect(() => {
    async function fetchData() {
      const response = await pb.collection("students").getFullList({});
      setRecords(response);
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

  return (
    <div>
      {!isLoading && (
        <div className="spage">
          <div className="chart">
            {/* render Chart component only if selectedRecord exists */}
            {selectedRecord && <Chart record={selectedRecord} />}
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
                        onClick={() => setSelectedRecord(record)}
                        className="btn btn-primary"
                      >
                        View Attendance
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
