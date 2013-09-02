[1mdiff --git a/app/assets/javascripts/reveal.js b/app/assets/javascripts/reveal.js[m
[1mindex 7f3566c..df452c0 100644[m
[1m--- a/app/assets/javascripts/reveal.js[m
[1m+++ b/app/assets/javascripts/reveal.js[m
[36m@@ -9,20 +9,19 @@[m [m$( document ).ready(function() {[m
 [m
   $('.hide-link').click(function(event) {[m
     event.preventDefault();[m
[31m-    $(this).closest('.revealable').slideToggle('fast');[m
[31m-    findClearable($(this).closest('.revealable')).val("");;[m
[32m+[m[32m    $(this).closest('fieldset').slideToggle('fast');[m
[32m+[m[32m    $(this).closest('fieldset').find('.clearable').val('');[m
     var selection = findParentofRevealableElements($(this));[m
     if(anyVisibleChildren(selection)) {[m
       toggleDisableable($(selection).children('.reveal-link'));[m
      }[m
[31m-    $(this).prev('input[type=hidden]').val('1')[m
[31m-    console.log( $(this).prev('input[type=hidden]').val() );[m
   });[m
 [m
[31m-[m
[31m-  // $('.destroy-link').click(function(event)) {[m
[31m-  //   event.preventDefault();[m
[31m-  // }[m
[32m+[m[32m  $('.destroy-link').click(function(event) {[m
[32m+[m[32m    event.preventDefault();[m
[32m+[m[32m    $(this).prev('input[type=hidden]').val('1')[m
[32m+[m[32m    $(this).closest('fieldset').find('.clearable').prop('disabled', true)[m
[32m+[m[32m  });[m
 [m
   function noHiddenChildren(element) {[m
     return element.children('.revealable:hidden:first').length === 0;[m
[1mdiff --git a/app/assets/stylesheets/forms.css.scss b/app/assets/stylesheets/forms.css.scss[m
[1mindex 7fd2013..41c1c25 100644[m
[1m--- a/app/assets/stylesheets/forms.css.scss[m
[1m+++ b/app/assets/stylesheets/forms.css.scss[m
[36m@@ -170,7 +170,7 @@[m [minput[type="submit"].under-input {[m
   }[m
 }[m
 [m
[31m- a.remove-fields, a.hide-link {[m
[32m+[m[32m a.remove-fields, a.hide-link, a.destroy-link {[m
   @include button-base;[m
   @include small-button-base;[m
   float:right;[m
[1mdiff --git a/app/views/shared/_entity.html.erb b/app/views/shared/_entity.html.erb[m
[1mindex eff17f7..3d0f405 100644[m
[1m--- a/app/views/shared/_entity.html.erb[m
[1m+++ b/app/views/shared/_entity.html.erb[m
[36m@@ -2,7 +2,7 @@[m
 [m
     <div class='field text require'>[m
       <%= f.hidden_field :_destroy %>[m
[31m-      <%= link_to 'X', '#', class:"hide-link #{hide_if_first_record(index)}" %>[m
[32m+[m[32m      <%= link_to 'X', '#', class:"#{hide_or_destroy record} #{hide_if_first_record(index)}" %>[m
     </div>[m
     <div class='togglable <%= hide_field_on_start_by_entity_type record %>'>[m
       <h3>Person<span>&nbsp;<%= link_to 'or company', '#', class: 'toggle', data: { :'model-type-to' => 'Company' } %></span></h3>[m
