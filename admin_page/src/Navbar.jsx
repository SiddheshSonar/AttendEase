import React, { useState } from "react";
import "./Navbar.css";
import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap/dist/js/bootstrap.bundle.min';
import Container from 'react-bootstrap/Container';
import Nav from 'react-bootstrap/Nav';
import Navbar from 'react-bootstrap/Navbar';
import Logo from "./assets/AE-logo.png"
import { pb } from "./login_page/Login";
import Box from '@mui/joy/Box';
import Button from '@mui/joy/Button';
import Divider from '@mui/joy/Divider';
import Modal from '@mui/joy/Modal';
import ModalDialog from '@mui/joy/ModalDialog';
import WarningRoundedIcon from '@mui/icons-material/WarningRounded';
import Typography from '@mui/joy/Typography';

function NavB() {
    const [open, setOpen] = useState(false);

    function handleLogout() {
        if (pb.authStore.isValid) {
            window.location.href = "/login";
            pb.authStore.clear();
        }
    }

    function confirmation() {
        setOpen(true)
    }
    return (
        <Navbar className="nav-bar" collapseOnSelect expand="lg" variant="dark" >
            <Container>
                <Navbar.Brand className="nav-title" href="./home">
                    <img
                        alt="Logo"
                        src={Logo}
                        width="30"
                        height="25"
                        className="d-inline-block align-top"
                    />{' '}
                    AttendWise Admin Page</Navbar.Brand>
                <Navbar.Toggle aria-controls="responsive-navbar-nav" />
                <Navbar.Collapse id="responsive-navbar-nav">
                    <Nav className="me-auto">
                    </Nav>
                    <Nav>
                        <Nav.Link href="./home">Home</Nav.Link>
                        <Nav.Link href="./view">View</Nav.Link>
                        <Nav.Link href="./update">Update</Nav.Link>
                        <Nav.Link onClick={() => setOpen(true)}>Logout</Nav.Link>
                    </Nav>
                </Navbar.Collapse>
            </Container>
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
                        Are you sure you want to Logout?
                    </Typography>
                    <Box sx={{ display: 'flex', gap: 1, justifyContent: 'flex-end', pt: 2 }}>
                        <Button variant="solid" color="neutral" onClick={handleLogout}>
                            Yes, I am Sure
                        </Button>
                        <Button variant="plain" color="neutral" onClick={() => setOpen(false)}>
                            Cancel
                        </Button>
                    </Box>
                </ModalDialog>
            </Modal>
        </Navbar>

    )
}

export default NavB