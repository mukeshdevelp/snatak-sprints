import React from "react";
import { Page, Grid } from "tabler-react";
import SiteWrapper from "./SiteWrapper.react";
import { Button, Form, FormGroup, Label, Input } from "reactstrap";
import { withFormik } from "formik";

var AttendanceForm = function (props) {
  var values = props.values;
  var handleChange = props.handleChange;
  var handleSubmit = props.handleSubmit;
  var isSubmitting = props.isSubmitting;

  return (
    <SiteWrapper>
      <Page.Card title="Employee Attendance">
        <Grid.Row>
          <Grid.Col md={6} lg={6} className="align-self-center">
            <Form onSubmit={handleSubmit}>
              <FormGroup>
                <Label>Employee ID</Label>
                <Input
                  type="text"
                  name="id"
                  value={values.id}
                  onChange={handleChange}
                  required
                />
              </FormGroup>
            <FormGroup>
                <Label>Employee Name</Label>
                <Input
                    type="text"
                    name="name"
                    value={values.name}
                    onChange={handleChange}
                    required
                />
            </FormGroup>
              <FormGroup>
                <Label>Status</Label>
                <Input
                  type="select"
                  name="status"
                  value={values.status}
                  onChange={handleChange}
                  required
                >
                  <option value="">Select Status</option>
                  <option value="present">Present</option>
                  <option value="absent">Absent</option>
                </Input>
              </FormGroup>

              <FormGroup>
                <Label>Date</Label>
                <Input
                  type="date"
                  name="date"
                  value={values.date}
                  onChange={handleChange}
                  required
                />
              </FormGroup>

              <Button color="primary" type="submit" disabled={isSubmitting}>
                {isSubmitting ? "Submitting..." : "Submit"}
              </Button>
            </Form>
          </Grid.Col>
        </Grid.Row>
      </Page.Card>
    </SiteWrapper>
  );
};

export default withFormik({
  mapPropsToValues: function () {
  return {
    id: "",
    name: "",   // 🔥 ADD THIS
    status: "",
    date: ""
  };
},


  handleSubmit: function (values, formikBag) {
    var resetForm = formikBag.resetForm;
    var setSubmitting = formikBag.setSubmitting;

    const payload = {
        id: values.id.trim(),
        name: values.name ? values.name.trim() : "",  // prevent undefined
        status: values.status.toLowerCase(),
        date: values.date
    };

    console.log("📤 Sending:", payload);


    fetch("/api/v1/attendance/create", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload)
    })
      .then(function (res) {
        return res.text().then(function (text) {
          if (!res.ok) {
            throw new Error(text || "Server error");
          }
          return text;
        });
      })
      .then(function () {
        alert("Attendance submitted successfully!");
        resetForm();
      })
      .catch(function (err) {
        alert("Attendance submission failed: " + err.message);
      })
      .finally(function () {
        setSubmitting(false);
      });
  }
})(AttendanceForm);
