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

//http://ricostacruz.com/nprogress/ 加载页面进度条
//https://github.com/rstacruz/nprogress
$(document).on('turbolinks:click', function() {
  NProgress.start();
});
$(document).on('turbolinks:render', function() {
  NProgress.done();
  NProgress.remove();
});