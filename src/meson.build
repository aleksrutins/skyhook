skyhook_sources = [
  'main.vala',
  'application.vala',
  'window.vala'
]

subdir('lib')
subdir('widgets')

skyhook_deps = [
  dependency('gtk4'),
  dependency('libadwaita-1'),
  dependency('json-glib-1.0'),
  dependency('libsoup-3.0')
]

skyhook_sources += gnome.compile_resources('skyhook-resources',
  'skyhook.gresource.xml',
  c_name: 'skyhook'
)

executable('skyhook', skyhook_sources,
  dependencies: skyhook_deps,
       install: true,
)
