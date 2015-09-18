
require 'Objects/PatternMatrixObject'
require 'Objects/PatternEditorObject'
require 'Objects/TrackObject'
require 'Objects/SequenceTrackObject'
require 'Objects/InstrumentObject'
require 'Objects/TransportObject'

Renoise = {
    pattern_matrix = PatternMatrixObject(),
    pattern_editor = PatternEditorObject(),
    track          = TrackObject(),
    sequence_track = SequenceTrackObject(),
    instrument     = InstrumentObject(),
    transport      = TransportObject(),
}


