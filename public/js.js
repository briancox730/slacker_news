function validateForm() {
  if (document.submit.author.value == "") {
    document.getElementById("author_alert").innerHTML = "*Required";
    return false;
  }
}
