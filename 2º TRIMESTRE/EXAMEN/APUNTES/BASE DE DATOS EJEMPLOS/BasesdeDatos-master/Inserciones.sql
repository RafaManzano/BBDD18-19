USE [TransLeo]
GO

INSERT INTO [dbo].[Provincias]
           ([C�digo_Postal]
           ,[Provincia])
     VALUES(
           48080
		   , 'Madriles')
GO
INSERT INTO [dbo].[Provincias]
           ([C�digo_Postal]
           ,[Provincia])
     VALUES(
           41710
		   ,'Seviya')
GO


INSERT INTO [dbo].[Centros]
           ([Denominaci�n]
           ,[Direcci�n]
           ,[Ciudad]
           ,[C�digo_Postal]
           ,[Tel�fono]
           ,[Tel�fono_Alternativo])
     VALUES
           ('Sentro Educatibo'
           ,'Al lao der Mah, prehmo'
           ,'Seviya'
           ,41710
           ,555555555
           ,555555569)
GO
INSERT INTO [dbo].[Centros]
           ([Denominaci�n]
           ,[Direcci�n]
           ,[Ciudad]
           ,[C�digo_Postal]
           ,[Tel�fono])
     VALUES
           ('Centro Educativo Serio'
           ,'C\San Juan Bosco n�59'
           ,'Madriles'
           ,48080
           ,955432121
		   )
go

select * Provincias