import React, { useState, useEffect, useRef, useMemo } from "react";
import Table from "react-bootstrap/Table";
import "../App.css";
import { pb } from "../login_page/Login";
import Button from '@mui/material/Button';
import DownloadIcon from '@mui/icons-material/Download';
import { useReactToPrint } from "react-to-print"

const PrintTable = (props) => {
    const PDFComponent = useRef();
    console.log(props.divison)
    const selectedDiv = props.divison;
    const [records, setRecords] = useState([]);
    const [course, setCourse] = useState([]);
    const [loading, setLoading] = useState(false)

    useEffect(() => {
        try {
            async function fetchData() {
                const response = await pb.collection("students").getFullList({});
                setRecords(response);
                const courses = await pb.collection("courses").getFullList({});
                setCourse(courses)
                setLoading(true)
            }
            fetchData();
        } catch (error) {
            console.log(error)
        }
    }, []);

    const getCellStyle = (percent) => {
        if (percent < 75) {
            return {backgroundColor: "gray"};
        } else {
            return {};
        }
    };

    const generatePDF = useReactToPrint({
        content: () => PDFComponent.current,
        documentTitle: `${props.divison} Divison Defaulter List`,
        onAfterPrint: () => alert("Data Saved in PDF"),
        onPrintError: () => alert("File Was Not Download"),
    });

    return (
       <div className="print-body">
         { loading && <div ref={PDFComponent} style={{width: "100%",height:"100%"}} className="def-list"> 
            <h2 className="def-list-title">Defaulter List {props.divison} Divison</h2>
            <Table bordered size="lg" variant="light" className="def-table">
            <thead>
                <tr>
                    <th className="pt-text">UID</th>
                    <th className="pt-text">Name</th>
                    {course.map((course) => (
                        <th className="pt-text" key={course.id}>{course.course_name}({course.lectures})</th>
                    ))}
                </tr>
            </thead>
            <tbody>
                {records.map((record) => {
                    let attended = 0
                    const subnames = course.map((sub) => sub.course_name)
                    const totalLecs = course.map((sub) => sub.lectures)
                    if (record.attendance) {
                        attended = subnames.map(
                            (subname) => (record.attendance[subname]?.length ?? 0)
                        );
                    }
                    else {
                      attended = Array(course.length).fill(0)
                    }
                    const percent = attended.map((num, idx) => {
                        const total = totalLecs[idx];
                        return ((num / total) * 100).toFixed(2);
                      });
                      const percentageAttended = attended.map((count, index) => {
                        return count / totalLecs[index];
                      });
                    
                    
                    if (record.division === selectedDiv) {
                        return (
                            <tr key={record.uid}>
                                <td className="pt-text">{record.uid}</td>
                                <td className="pt-text">{record.name}</td>
                                {course.map((item,index) => {
                                     return (
                                         <td className="pt-text" key={item.course_id} style={getCellStyle(percent[index])}>
                                            {percent[index]}%
                                         </td>
                                    );
                                })}
                            </tr>
                        );
                    } else {
                        return null;
                    }
                })}
            </tbody>
        </Table>
        </div>}
        <Button
              variant='contained'
              color='success'
              className='dwn-btn btn btn-primary'
              onClick={generatePDF}
            >
              <DownloadIcon /> Download List
            </Button>
       </div>
    );
};

export default PrintTable;
