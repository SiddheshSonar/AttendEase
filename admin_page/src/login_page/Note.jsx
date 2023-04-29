import React, { useState } from 'react';
import Alert from 'react-bootstrap/Alert';

function Note(props) {
  if (props.loginStat) {
    return (
    //     <Alert variant="success">
    //     <Alert.Heading>How's it going?!</Alert.Heading>
    //     <p>
    //       Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget
    //       lacinia odio sem nec elit. Cras mattis consectetur purus sit amet
    //       fermentum.
    //     </p>
    //   </Alert>
      <div></div>
    );
  }
  else {
    return (
    //     <Alert variant="danger">
    //     <Alert.Heading>Oh snap! You got an error!</Alert.Heading>
    //     <p>
    //       Change this and that and try again. Duis mollis, est non commodo
    //       luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit.
    //       Cras mattis consectetur purus sit amet fermentum.
    //     </p>
    //   </Alert>
    <div></div>
    )
  }
}

export default Note