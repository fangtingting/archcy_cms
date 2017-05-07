function toggle(m){
  var checked = m.checked;
  var col = document.getElementsByTagName("input");
  for (var i=0;i<col.length;i++) {
    if (col[i].getAttribute('type') == 'checkbox'){
      col[i].checked= checked;
    }
  }
}