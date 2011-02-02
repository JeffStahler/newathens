/*!
 * jQuery Form Plugin
 * version: 2.52 (07-DEC-2010)
 * @requires jQuery v1.3.2 or later
 *
 * Examples and documentation at: http://malsup.com/jquery/form/
 * Dual licensed under the MIT and GPL licenses:
 *   http://www.opensource.org/licenses/mit-license.php
 *   http://www.gnu.org/licenses/gpl.html
 */
(function(b){b.fn.ajaxSubmit=function(t){if(!this.length){a("ajaxSubmit: skipping submit process - no element selected");return this}if(typeof t=="function"){t={success:t}}var h=this.attr("action");var d=(typeof h==="string")?b.trim(h):"";if(d){d=(d.match(/^([^#]+)/)||[])[1]}d=d||window.location.href||"";t=b.extend(true,{url:d,type:this.attr("method")||"GET",iframeSrc:/^https/i.test(window.location.href||"")?"javascript:false":"about:blank"},t);var u={};this.trigger("form-pre-serialize",[this,t,u]);if(u.veto){a("ajaxSubmit: submit vetoed via form-pre-serialize trigger");return this}if(t.beforeSerialize&&t.beforeSerialize(this,t)===false){a("ajaxSubmit: submit aborted via beforeSerialize callback");return this}var f,p,m=this.formToArray(t.semantic);if(t.data){t.extraData=t.data;for(f in t.data){if(t.data[f] instanceof Array){for(var i in t.data[f]){m.push({name:f,value:t.data[f][i]})}}else{p=t.data[f];p=b.isFunction(p)?p():p;m.push({name:f,value:p})}}}if(t.beforeSubmit&&t.beforeSubmit(m,this,t)===false){a("ajaxSubmit: submit aborted via beforeSubmit callback");return this}this.trigger("form-submit-validate",[m,this,t,u]);if(u.veto){a("ajaxSubmit: submit vetoed via form-submit-validate trigger");return this}var c=b.param(m);if(t.type.toUpperCase()=="GET"){t.url+=(t.url.indexOf("?")>=0?"&":"?")+c;t.data=null}else{t.data=c}var s=this,l=[];if(t.resetForm){l.push(function(){s.resetForm()})}if(t.clearForm){l.push(function(){s.clearForm()})}if(!t.dataType&&t.target){var r=t.success||function(){};l.push(function(n){var k=t.replaceTarget?"replaceWith":"html";b(t.target)[k](n).each(r,arguments)})}else{if(t.success){l.push(t.success)}}t.success=function(w,n,x){var v=t.context||t;for(var q=0,k=l.length;q<k;q++){l[q].apply(v,[w,n,x||s,s])}};var g=b("input:file",this).length>0;var e="multipart/form-data";var j=(s.attr("enctype")==e||s.attr("encoding")==e);if(t.iframe!==false&&(g||t.iframe||j)){if(t.closeKeepAlive){b.get(t.closeKeepAlive,o)}else{o()}}else{b.ajax(t)}this.trigger("form-submit-notify",[this,t]);return this;function o(){var k=s[0];if(b(":input[name=submit],:input[id=submit]",k).length){alert('Error: Form elements must not have name or id of "submit".');return}var z=b.extend(true,{},b.ajaxSettings,t);z.context=z.context||z;var C="jqFormIO"+(new Date().getTime()),x="_"+C;window[x]=function(){var n=q.data("form-plugin-onload");if(n){n();window[x]=undefined;try{delete window[x]}catch(L){}}};var q=b('<iframe id="'+C+'" name="'+C+'" src="'+z.iframeSrc+'" onload="window[\'_\'+this.id]()" />');var y=q[0];q.css({position:"absolute",top:"-1000px",left:"-1000px"});var v={aborted:0,responseText:null,responseXML:null,status:0,statusText:"n/a",getAllResponseHeaders:function(){},getResponseHeader:function(){},setRequestHeader:function(){},abort:function(){this.aborted=1;q.attr("src",z.iframeSrc)}};var H=z.global;if(H&&!b.active++){b.event.trigger("ajaxStart")}if(H){b.event.trigger("ajaxSend",[v,z])}if(z.beforeSend&&z.beforeSend.call(z.context,v,z)===false){if(z.global){b.active--}return}if(v.aborted){return}var D=false;var G=0;var w=k.clk;if(w){var E=w.name;if(E&&!w.disabled){z.extraData=z.extraData||{};z.extraData[E]=w.value;if(w.type=="image"){z.extraData[E+".x"]=k.clk_x;z.extraData[E+".y"]=k.clk_y}}}function F(){var N=s.attr("target"),L=s.attr("action");k.setAttribute("target",C);if(k.getAttribute("method")!="POST"){k.setAttribute("method","POST")}if(k.getAttribute("action")!=z.url){k.setAttribute("action",z.url)}if(!z.skipEncodingOverride){s.attr({encoding:"multipart/form-data",enctype:"multipart/form-data"})}if(z.timeout){setTimeout(function(){G=true;B()},z.timeout)}var M=[];try{if(z.extraData){for(var O in z.extraData){M.push(b('<input type="hidden" name="'+O+'" value="'+z.extraData[O]+'" />').appendTo(k)[0])}}q.appendTo("body");q.data("form-plugin-onload",B);k.submit()}finally{k.setAttribute("action",L);if(N){k.setAttribute("target",N)}else{s.removeAttr("target")}b(M).remove()}}if(z.forceSync){F()}else{setTimeout(F,10)}var J,K,I=50;function B(){if(D){return}q.removeData("form-plugin-onload");var M=true;try{if(G){throw"timeout"}K=y.contentWindow?y.contentWindow.document:y.contentDocument?y.contentDocument:y.document;var Q=z.dataType=="xml"||K.XMLDocument||b.isXMLDoc(K);a("isXml="+Q);if(!Q&&window.opera&&(K.body==null||K.body.innerHTML=="")){if(--I){a("requeing onLoad callback, DOM not available");setTimeout(B,250);return}}D=true;v.responseText=K.documentElement?K.documentElement.innerHTML:null;v.responseXML=K.XMLDocument?K.XMLDocument:K;v.getResponseHeader=function(S){var R={"content-type":z.dataType};return R[S]};var P=/(json|script)/.test(z.dataType);if(P||z.textarea){var L=K.getElementsByTagName("textarea")[0];if(L){v.responseText=L.value}else{if(P){var O=K.getElementsByTagName("pre")[0];var n=K.getElementsByTagName("body")[0];if(O){v.responseText=O.textContent}else{if(n){v.responseText=n.innerHTML}}}}}else{if(z.dataType=="xml"&&!v.responseXML&&v.responseText!=null){v.responseXML=A(v.responseText)}}J=b.httpData(v,z.dataType)}catch(N){a("error caught:",N);M=false;v.error=N;b.handleError(z,v,"error",N)}if(v.aborted){a("upload aborted");M=false}if(M){z.success.call(z.context,J,"success",v);if(H){b.event.trigger("ajaxSuccess",[v,z])}}if(H){b.event.trigger("ajaxComplete",[v,z])}if(H&&!--b.active){b.event.trigger("ajaxStop")}if(z.complete){z.complete.call(z.context,v,M?"success":"error")}setTimeout(function(){q.removeData("form-plugin-onload");q.remove();v.responseXML=null},100)}function A(n,L){if(window.ActiveXObject){L=new ActiveXObject("Microsoft.XMLDOM");L.async="false";L.loadXML(n)}else{L=(new DOMParser()).parseFromString(n,"text/xml")}return(L&&L.documentElement&&L.documentElement.tagName!="parsererror")?L:null}}};b.fn.ajaxForm=function(c){if(this.length===0){var d={s:this.selector,c:this.context};if(!b.isReady&&d.s){a("DOM not ready, queuing ajaxForm");b(function(){b(d.s,d.c).ajaxForm(c)});return this}a("terminating; zero elements found by selector"+(b.isReady?"":" (DOM not ready)"));return this}return this.ajaxFormUnbind().bind("submit.form-plugin",function(f){if(!f.isDefaultPrevented()){f.preventDefault();b(this).ajaxSubmit(c)}}).bind("click.form-plugin",function(j){var i=j.target;var g=b(i);if(!(g.is(":submit,input:image"))){var f=g.closest(":submit");if(f.length==0){return}i=f[0]}var h=this;h.clk=i;if(i.type=="image"){if(j.offsetX!=undefined){h.clk_x=j.offsetX;h.clk_y=j.offsetY}else{if(typeof b.fn.offset=="function"){var k=g.offset();h.clk_x=j.pageX-k.left;h.clk_y=j.pageY-k.top}else{h.clk_x=j.pageX-i.offsetLeft;h.clk_y=j.pageY-i.offsetTop}}}setTimeout(function(){h.clk=h.clk_x=h.clk_y=null},100)})};b.fn.ajaxFormUnbind=function(){return this.unbind("submit.form-plugin click.form-plugin")};b.fn.formToArray=function(q){var p=[];if(this.length===0){return p}var d=this[0];var g=q?d.getElementsByTagName("*"):d.elements;if(!g){return p}var k,h,f,r,e,m,c;for(k=0,m=g.length;k<m;k++){e=g[k];f=e.name;if(!f){continue}if(q&&d.clk&&e.type=="image"){if(!e.disabled&&d.clk==e){p.push({name:f,value:b(e).val()});p.push({name:f+".x",value:d.clk_x},{name:f+".y",value:d.clk_y})}continue}r=b.fieldValue(e,true);if(r&&r.constructor==Array){for(h=0,c=r.length;h<c;h++){p.push({name:f,value:r[h]})}}else{if(r!==null&&typeof r!="undefined"){p.push({name:f,value:r})}}}if(!q&&d.clk){var l=b(d.clk),o=l[0];f=o.name;if(f&&!o.disabled&&o.type=="image"){p.push({name:f,value:l.val()});p.push({name:f+".x",value:d.clk_x},{name:f+".y",value:d.clk_y})}}return p};b.fn.formSerialize=function(c){return b.param(this.formToArray(c))};b.fn.fieldSerialize=function(d){var c=[];this.each(function(){var h=this.name;if(!h){return}var f=b.fieldValue(this,d);if(f&&f.constructor==Array){for(var g=0,e=f.length;g<e;g++){c.push({name:h,value:f[g]})}}else{if(f!==null&&typeof f!="undefined"){c.push({name:this.name,value:f})}}});return b.param(c)};b.fn.fieldValue=function(h){for(var g=[],e=0,c=this.length;e<c;e++){var f=this[e];var d=b.fieldValue(f,h);if(d===null||typeof d=="undefined"||(d.constructor==Array&&!d.length)){continue}d.constructor==Array?b.merge(g,d):g.push(d)}return g};b.fieldValue=function(c,j){var e=c.name,p=c.type,q=c.tagName.toLowerCase();if(j===undefined){j=true}if(j&&(!e||c.disabled||p=="reset"||p=="button"||(p=="checkbox"||p=="radio")&&!c.checked||(p=="submit"||p=="image")&&c.form&&c.form.clk!=c||q=="select"&&c.selectedIndex==-1)){return null}if(q=="select"){var k=c.selectedIndex;if(k<0){return null}var m=[],d=c.options;var g=(p=="select-one");var l=(g?k+1:d.length);for(var f=(g?k:0);f<l;f++){var h=d[f];if(h.selected){var o=h.value;if(!o){o=(h.attributes&&h.attributes.value&&!(h.attributes.value.specified))?h.text:h.value}if(g){return o}m.push(o)}}return m}return b(c).val()};b.fn.clearForm=function(){return this.each(function(){b("input,select,textarea",this).clearFields()})};b.fn.clearFields=b.fn.clearInputs=function(){return this.each(function(){var d=this.type,c=this.tagName.toLowerCase();if(d=="text"||d=="password"||c=="textarea"){this.value=""}else{if(d=="checkbox"||d=="radio"){this.checked=false}else{if(c=="select"){this.selectedIndex=-1}}}})};b.fn.resetForm=function(){return this.each(function(){if(typeof this.reset=="function"||(typeof this.reset=="object"&&!this.reset.nodeType)){this.reset()}})};b.fn.enable=function(c){if(c===undefined){c=true}return this.each(function(){this.disabled=!c})};b.fn.selected=function(c){if(c===undefined){c=true}return this.each(function(){var d=this.type;if(d=="checkbox"||d=="radio"){this.checked=c}else{if(this.tagName.toLowerCase()=="option"){var e=b(this).parent("select");if(c&&e[0]&&e[0].type=="select-one"){e.find("option").selected(false)}this.selected=c}}})};function a(){if(b.fn.ajaxSubmit.debug){var c="[jquery.form] "+Array.prototype.join.call(arguments,"");if(window.console&&window.console.log){window.console.log(c)}else{if(window.opera&&window.opera.postError){window.opera.postError(c)}}}}})(jQuery);