(function() {
  var template = Handlebars.template, templates = Handlebars.templates = Handlebars.templates || {};
templates['form'] = template(function (Handlebars,depth0,helpers,partials,data) {
  helpers = helpers || Handlebars.helpers;
  var buffer = "", stack1, stack2, foundHelper, tmp1, self=this, functionType="function", helperMissing=helpers.helperMissing, undef=void 0, escapeExpression=this.escapeExpression;

function program1(depth0,data) {
  
  var buffer = "", stack1;
  buffer += "\n        <option value=\"";
  foundHelper = helpers.id;
  stack1 = foundHelper || depth0.id;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "id", { hash: {} }); }
  buffer += escapeExpression(stack1) + "\">";
  foundHelper = helpers.number;
  stack1 = foundHelper || depth0.number;
  if(typeof stack1 === functionType) { stack1 = stack1.call(depth0, { hash: {} }); }
  else if(stack1=== undef) { stack1 = helperMissing.call(depth0, "number", { hash: {} }); }
  buffer += escapeExpression(stack1) + "</option>\n      ";
  return buffer;}

  buffer += "<form id=\"create\">\n  <div>\n    <label for=\"process_id\">Process</label>\n    <select id=\"process_id\" name=\"process_id\">\n      ";
  foundHelper = helpers.processes;
  stack1 = foundHelper || depth0.processes;
  stack2 = helpers.each;
  tmp1 = self.program(1, program1, data);
  tmp1.hash = {};
  tmp1.fn = tmp1;
  tmp1.inverse = self.noop;
  stack1 = stack2.call(depth0, stack1, tmp1);
  if(stack1 || stack1 === 0) { buffer += stack1; }
  buffer += "\n    </select>\n  </div>\n\n  <div>\n  <label for=\"expiry_date\">Expiry Date</label>\n  <input id=\"expiry_date\" name=\"expiry_date\" class=\"datepicker\" type=\"text\" />\n  </div>\n\n  <div>\n  <label for=\"comments\">Comments</label>\n  <textarea id=\"comments\" name=\"comments\"></textarea>\n  </div>\n\n  <input type=\"submit\" value=\"Submit\" />\n</form>\n";
  return buffer;});
})();
