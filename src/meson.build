skyhook_sources = [
  'main.vala',
  'application.vala',
  'window.vala',
]

skyhook_deps = [
  dependency('gtk4'),
  dependency('libadwaita-1'),
]

skyhook_sources += gnome.compile_resources('skyhook-resources',
  'skyhook.gresource.xml',
  c_name: 'skyhook'
)

executable('skyhook', skyhook_sources,
  dependencies: skyhook_deps,
       install: true,
)
