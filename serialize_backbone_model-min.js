!function(){Backbone.Model.prototype.original_save=Backbone.Model.prototype.save;Backbone.Model.prototype.save=function(e,t,u){var n,o,r,s=this;if(!this._requestQueue){this._requestQueue=[]}this._requestQueue.push({key:e,val:t,options:u});if(this._requestQueue.length>1){return null}if(e===null||typeof e==="undefined"||typeof e==="object"){u=t}if(!u){u={}}r=u.success;o=u.error;n=function(){var e,t;t=_.last(s._requestQueue);e=s._requestQueue.length;s._requestQueue=[];if(e>1){return s.save(t.key,t.val,t.options)}};u.success=function(e,t,u){if(r){r(e,t,u)}return n()};u.error=function(e,t,u){if(o){o(e,t,u)}return n()};if(e===null||typeof e==="undefined"||typeof e==="object"){t=u}return this.original_save(e,t,u)}}.call(this);
//# sourceMappingURL=serialize_backbone_model-min.map