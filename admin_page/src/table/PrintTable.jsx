import React, { useState, useEffect, useRef } from "react";
import Table from "react-bootstrap/Table";
import "../App.css";
import { pb } from "../login_page/Login";

const PrintTable = (props) => {
    const PDFComponent = useRef();
    console.log(props.divison)
    const selectedDiv = props.divison;
    // console.log(selectedRecord);
    const [records, setRecords] = useState([]);
    const [course, setCourse] = useState([]);
    const [loading, setLoading] = useState(false)
    // const [selectedRecord, setSelectedRecord] = useState(null);

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

    return (
       <div>
         { loading && <Table bordered size="lg" variant="light" className="def-table">
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
                    if (record.division === selectedDiv) {
                        return (
                            <tr key={record.uid}>
                                <td className="pt-text">{record.uid}</td>
                                <td className="pt-text">{record.name}</td>
                                {course.map((item) => {
                                     const attended = record.attendance[item.course_name];
                                     const courseName = item.course_name
                                     console.log(courseName)
                                     console.log(attended.length)
                                     const attendance = ((attended / item.lectures) * 100).toFixed(2);
                                     return (
                                         <td className="pt-text" key={item.course_id}>
                                             {item.course_name}%
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
        </Table>}
       </div>
    );
};

export default PrintTable;
