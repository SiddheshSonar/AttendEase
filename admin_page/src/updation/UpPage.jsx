import React, { useState, useEffect } from 'react';
import { AdapterDayjs } from '@mui/x-date-pickers/AdapterDayjs';
import { LocalizationProvider } from '@mui/x-date-pickers/LocalizationProvider';
import { StaticDateTimePicker } from '@mui/x-date-pickers';
import InputLabel from '@mui/material/InputLabel';
import MenuItem from '@mui/material/MenuItem';
import FormControl from '@mui/material/FormControl';
import Select from '@mui/material/Select';
import Box from '@mui/joy/Box';
import Button from '@mui/joy/Button';
import Divider from '@mui/joy/Divider';
import Modal from '@mui/joy/Modal';
import ModalClose from '@mui/joy/ModalClose';
import ModalDialog from '@mui/joy/ModalDialog';
import WarningRoundedIcon from '@mui/icons-material/WarningRounded';
import Typography from '@mui/joy/Typography';
import { pb } from '../login_page/Login';

const UpPage = ({ op, record, course }) => {
    const [date, setDate] = useState("")
    const [selectedCourse, setSelectedCourse] = useState("")
    const [open, setOpen] = useState(false);
    const [variant, setVariant] = useState(undefined);
    const [changes, setChanges] = useState(undefined);
    const [newData, setNewData] = useState(record);
    const courses = (Object.keys(record.attendance))

    const handleAccept = (newDate) => {
        setDate(newDate);
    };

    const handleClose = () => {
        setDate(null);
    };

    const handleChange = (event) => {
        setSelectedCourse(event.target.value);
    };

    // useEffect(() => {
    //     async function getCourses() {
    //         try {
    //             const course_info = await pb.collection('courses').getOne(course.id, {
    //                 expand: 'students_enrolled.username',
    //             });
    //             console.log(course_info);
    //         } catch (error) {
    //             console.log(error);
    //         }
    //     }
    //     getCourses()
    // }, [])

    async function updateData(data) {
        try {
            const rec = await pb.collection('students').update(record.id, data);
            return true
        } catch (error) {
            console.log(error)
            return false
        }
    }

    const handleConfirmation = () => {
        const lecDate = new Date(date);
        const newDate = lecDate.toISOString();
        console.log(lecDate)
        console.log(newDate)
        setOpen(false)
        const student = record.attendance
        if (op === "CONFIRM ADDITION" && date && selectedCourse) {
            setVariant('soft')
            console.log("Data Added")
            student[selectedCourse].push(newDate)
            console.log(student[selectedCourse])
            setNewData(prevData => ({
                ...prevData,
                attendance: {
                    ...prevData.attendance,
                    [selectedCourse]: student[selectedCourse]
                }
            }));
            console.log(newData)
            if (updateData(newData)) {
                setChanges("Attendance Added Successfully!")
            }
            else {
                setChanges("Error Occured!")
            }

        }
        else if (op === "CONFIRM DELETION" && date && selectedCourse) {
            setVariant('soft')
            console.log("Data Deleted")
            // console.log(student[selectedCourse])
            const attendanceArr = student[selectedCourse];
            if (attendanceArr.length > 0) {
                const afterDelete = attendanceArr.filter((atdDate) => {
                    const studentDate = new Date(atdDate);
                    return (
                        studentDate.getHours() !== lecDate.getHours() ||
                        studentDate.getDate() !== lecDate.getDate() ||
                        studentDate.getMonth() !== lecDate.getMonth() ||
                        studentDate.getFullYear() !== lecDate.getFullYear()
                    );
                });
                student[selectedCourse] = afterDelete;
            }
            setNewData(prevData => ({
                ...prevData,
                attendance: {
                    ...prevData.attendance,
                    [selectedCourse]: student[selectedCourse]
                }
            }));
            console.log(newData)
            if (updateData(newData)) {
                setChanges("Attendance Deleted Successfully!")
            }
            else {
                setChanges("Error Occured!")
            }
        }
        else {
            setVariant('solid')
            console.log("No Change in Data")
            setChanges("Please Fill all the Information")
        }
    }

    const courseNames = courses.map((course, index) =>
        <MenuItem key={index} value={course}>{course}</MenuItem>
    )

    return (
        <div className='up-page'>
            <h1 className='up-title'>{op === "CONFIRM ADDITION" ? "Adding to" : "Deleting from"} {record.name}'s Attendance</h1>
            <FormControl sx={{ m: 1, minWidth: 150 }}>
                <InputLabel id="demo-simple-select-helper-label" sx={{ color: 'black', fontWeight: 700 }}>Subject</InputLabel>
                <Select
                    labelId="demo-simple-select-helper-label"
                    id="demo-simple-select-helper"
                    value={selectedCourse}
                    label="Subject"
                    onChange={handleChange}
                    sx={{
                        borderColor: '#ccc',
                        borderWidth: 1,
                        borderRadius: 4,
                        backgroundColor: '#fff',
                        '&:hover': {
                            backgroundColor: '#f5f5f5',
                        },
                    }}
                >
                    <MenuItem value="">
                        <em>None</em>
                    </MenuItem>
                    {courseNames}
                </Select>
            </FormControl>
            <div className="date-time">
                <LocalizationProvider dateAdapter={AdapterDayjs}>
                    <StaticDateTimePicker orientation="landscape"
                        label="Date and Time"
                        value={date}
                        onChange={(newValue) => setDate(newValue)}
                        onClose={handleClose}
                        onAccept={handleAccept}
                        sx={{ borderRadius: "20px" }}
                    />
                </LocalizationProvider>
            </div>
            {selectedCourse && date && <div className='atd-info'>
                <h2 className='info-title'>Attendance Info</h2>
                <h4 className='a-info'>Subject: {selectedCourse}</h4>
                <h4 className='a-info'>Date and Time: {new Date(date).toLocaleString('en-US', { timeZone: 'Asia/Kolkata' })}</h4>


            </div>}
            <button className='main-btn btn btn-primary' onClick={() => setOpen(true)}>{op}</button>
            <Modal open={open} onClose={() => setOpen(false)}>
                <ModalDialog
                    variant="outlined"
                    role="alertdialog"
                    aria-labelledby="alert-dialog-modal-title"
                    aria-describedby="alert-dialog-modal-description"
                >
                    <Typography
                        id="alert-dialog-modal-title"
                        component="h2"
                        startDecorator={<WarningRoundedIcon />}
                    >
                        Confirmation
                    </Typography>
                    <Divider />
                    <Typography id="alert-dialog-modal-description" textColor="text.tertiary">
                        Are you sure you want to make these changes?
                    </Typography>
                    <Box sx={{ display: 'flex', gap: 1, justifyContent: 'flex-end', pt: 2 }}>
                        <Button variant="solid" color="neutral" onClick={handleConfirmation}>
                            Yes, I am Sure
                        </Button>
                        <Button variant="plain" color="neutral" onClick={() => setOpen(false)}>
                            Cancel
                        </Button>
                    </Box>
                </ModalDialog>
            </Modal>
            <Modal open={!!variant} onClose={() => setVariant(undefined)}>
                <ModalDialog
                    aria-labelledby="variant-modal-title"
                    aria-describedby="variant-modal-description"
                    variant={variant}
                >
                    <ModalClose />
                    <Typography id="variant-modal-title" component="h2" level="inherit">
                        Message
                    </Typography>
                    <Typography id="variant-modal-description" textColor="inherit">
                        {changes}
                    </Typography>
                </ModalDialog>
            </Modal>
        </div>
    );
};

export default UpPage;