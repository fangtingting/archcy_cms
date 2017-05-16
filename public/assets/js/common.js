// 全选跟全不选操作
function toggle(m){
  var checked = m.checked;
  var col = document.getElementsByTagName("input");
  for (var i=0;i<col.length;i++) {
    if (col[i].getAttribute('type') == 'checkbox'){
      col[i].checked= checked;
    }
  }
}

// 获取选中的checkbox的值
function get_selected_ids(table_name){
  var ids = new Array();
  var selected_options = $('#'+table_name+' td :checkbox:checked');
  if (selected_options.length > 0) {
    for (var i = 0; i < selected_options.length; i++) {
      ids.push($(selected_options[i]).val());
    }
  } 
  return ids
}

function show_dialog(obj,id,width,height){
  title = $(obj).data('title');
  url = $(obj).data('url')
  $("#"+id).html("加载中...").load(url).dialog({title: total_title, width: width, height: height});
}

$(function(){
  $('[data-toggle="popover"]').popover()
});