function validateForm() {
    var name = document.forms["myForm"].elements[1].value;
    var email = document.forms["myForm"].elements[2].value;
    var msg = document.forms["myForm"].elements[3].value;
    var company = document.forms["myForm"].elements[4].value;
    var date = document.forms["myForm"].elements[5].value;
    var number = document.forms["myForm"].elements[6].value;
    var x;

    var selectedDate = $('#datepicker').datepicker('getDate');
    var currentDate = new Date();
    currentDate.setHours(0,0,0,0);

    var futureDate = new Date();
    futureDate.setHours(0,0,0,0);
    futureDate.setDate(futureDate.getDate() + 14);

    x = document.getElementById("validation");
    var errorMessage = "Please check your form!<br>";
    var foundErrors = false;

    if ((name == "") || (email == "") || (msg == "") || (company == "") || (date == "")) {
        x.classList.add("error_message");
        x.innerHTML = errorMessage + "All fields must be filled out.<br>";
        return false;
    }

    if (selectedDate <= currentDate) {
        errorMessage += "Date cannot be in the past.<br>";
        foundErrors = true;
    }
    if (selectedDate > futureDate) {
        errorMessage += "Date must be within 2 weeks.<br>";
        foundErrors = true;
    }

    if (number < 10 || number > 90) {
        errorMessage += "Important number must be between 10 and 90.<br>";
        foundErrors = true;
    }

    if (foundErrors) {
        x.classList.add("error_message");
        x.innerHTML = errorMessage;
        return false;
    }

    x.innerHTML = "Submit successful!";

}

async function myFunction() {
    document.getElementById("myPopup");
    popup.classList.toggle("show");
}
