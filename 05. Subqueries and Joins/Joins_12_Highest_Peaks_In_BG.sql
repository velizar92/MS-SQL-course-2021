SELECT 
	c.[CountryCode],
	m.[MountainRange],
	p.[PeakName],
	p.[Elevation]
FROM Peaks AS p
JOIN Mountains AS m
ON p.[MountainId] = m.[Id]
JOIN MountainsCountries AS mc
ON m.[Id] = mc.MountainId
JOIN Countries AS c
ON mc.CountryCode = c.CountryCode
WHERE p.[Elevation] > '2835' AND c.[CountryCode] = 'BG'
ORDER BY p.Elevation DESC


