function focusField(event, key, field) {
  const tag = event.target.tagName;
  if (field === null || event.defaultPrevented ||
      event.key !== key || tag === 'INPUT' || tag === 'TEXTAREA') {
    return; // Do nothing if the event was already processed or key was not s
  }

  field.focus();
  event.preventDefault();
}

function searchKeydown(event) {
  focusField(event, 's', document.getElementById('search-card'))
}

function adjustKey(event) {
  focusField(event, 'a', document.getElementById('adjust'))
}

function setupShortcuts() {
  document.addEventListener('keydown', adjustKey, true);
  document.addEventListener('keydown', searchKeydown, true);
}

function removeShortcuts() {
  document.addEventListener('keydown', adjustKey, true);
  document.removeEventListener('keydown', searchKeydown, true);
}

document.addEventListener('turbolinks:load', setupShortcuts);
document.addEventListener('turbolinks:before-cache', removeShortcuts);
