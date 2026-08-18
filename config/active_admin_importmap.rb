# frozen_string_literal: true

# Packages used only inside ActiveAdmin. ActiveAdmin renders its own importmap,
# separate from the application's config/importmap.rb.
pin 'leaflet', to: 'leaflet/leaflet.js', preload: false # @1.9.4
pin 'leaflet.markercluster', to: 'leaflet/leaflet.markercluster.js', preload: false # @1.5.3
pin '@geoman-io/leaflet-geoman-free',
    to: '@geoman-io--leaflet-geoman-free.js',
    preload: false # @2.20.0
pin '@turf/boolean-point-in-polygon',
    to: '@turf--boolean-point-in-polygon.js',
    preload: false # @7.4.0
pin 'papaparse', preload: false # @5.6.0
pin '@turf/helpers', to: '@turf--helpers.js', preload: false # @7.4.0
pin '@turf/invariant', to: '@turf--invariant.js', preload: false # @7.4.0
pin 'point-in-polygon-hao', preload: false # @1.2.4
pin 'robust-predicates', preload: false # @3.0.3
