!function(){Backbone.Model.prototype.original_save=Backbone.Model.prototype.save;Backbone.Model.prototype.save=function(e,t,u){var s,i,r,n,o=this;if(!this._requestQueue){this._requestQueue=[]}this._requestQueue.push({key:e,val:t,options:u});s=this.attributes;if(e===null||typeof e==="undefined"||typeof e==="object"){s=e;u=t}else{(s={})[e]=t}if(!u){u={}}if(s&&(!u||!u.wait)&&!this.set(s,u)){return false}if(this._requestQueue.length>1){return false}n=u.success;r=u.error;i=function(){var e,t;t=_.last(o._requestQueue);e=o._requestQueue.length;o._requestQueue=[];if(e>1){return o.save(t.key,t.val,t.options)}};u.success=function(e,t,u){if(n){n(e,t,u)}return i()};u.error=function(e,t,u){if(r){r(e,t,u)}return i()};if(e===null||typeof e==="undefined"||typeof e==="object"){t=u}return this.original_save(e,t,u)}}.call(this);
//# sourceMappingURL=serialize_backbone_model-min.map