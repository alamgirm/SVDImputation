function nrms = CalNRMS(A, B)
%function nrms = CalNRMS(A, B)
% calculates normalized RMS error
nrms = norm(A-B,'fro')/norm(B,'fro');
