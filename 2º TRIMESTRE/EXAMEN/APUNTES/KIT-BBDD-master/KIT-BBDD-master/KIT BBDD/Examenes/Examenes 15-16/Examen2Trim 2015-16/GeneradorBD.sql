CREATE DATABASE [CasinOnLinePrevia]
GO
USE [CasinOnLinePrevia]
GO
/****** Object:  Table [dbo].[COL_Apuestas]    Script Date: 08/03/2016 18:08:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COL_Apuestas](
	[IDJugador] [int] NOT NULL,
	[IDMesa] [smallint] NOT NULL,
	[IDJugada] [int] NOT NULL,
	[Tipo] [tinyint] NOT NULL,
	[Importe] [money] NOT NULL,
 CONSTRAINT [PK_Apuestas] PRIMARY KEY CLUSTERED 
(
	[IDJugador] ASC,
	[IDMesa] ASC,
	[IDJugada] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[COL_Jugadas]    Script Date: 08/03/2016 18:08:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COL_Jugadas](
	[IDMesa] [smallint] NOT NULL,
	[IDJugada] [int] NOT NULL,
	[MomentoJuega] [datetime] NULL,
	[NoVaMas] [bit] NOT NULL DEFAULT ((0)),
	[Numero] [tinyint] NULL,
 CONSTRAINT [PK_Jugadas] PRIMARY KEY CLUSTERED 
(
	[IDMesa] ASC,
	[IDJugada] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[COL_Jugadores]    Script Date: 08/03/2016 18:08:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COL_Jugadores](
	[ID] [int] NOT NULL,
	[Nombre] [nvarchar](15) NOT NULL,
	[Apellidos] [nvarchar](25) NOT NULL,
	[Nick] [nchar](12) NOT NULL,
	[PassWord] [nchar](12) NOT NULL,
	[FechaNacimiento] [date] NOT NULL,
	[Saldo] [money] NOT NULL DEFAULT ((0)),
	[Credito] [money] NULL DEFAULT ((0)),
 CONSTRAINT [PK_Jugadores] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_Nick] UNIQUE NONCLUSTERED 
(
	[Nick] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[COL_Mesas]    Script Date: 08/03/2016 18:08:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COL_Mesas](
	[ID] [smallint] NOT NULL,
	[LimiteJugada] [money] NULL,
	[Saldo] [money] NULL DEFAULT ((0)),
 CONSTRAINT [PK_Mesas] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[COL_NumerosApuesta]    Script Date: 08/03/2016 18:08:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[COL_NumerosApuesta](
	[IDJugador] [int] NOT NULL,
	[IDMesa] [smallint] NOT NULL,
	[IDJugada] [int] NOT NULL,
	[Numero] [tinyint] NOT NULL,
 CONSTRAINT [PK_NumerosJugada] PRIMARY KEY CLUSTERED 
(
	[IDJugador] ASC,
	[IDMesa] ASC,
	[IDJugada] ASC,
	[Numero] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[COL_TiposApuesta]    Script Date: 08/03/2016 18:08:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[COL_TiposApuesta](
	[ID] [tinyint] NOT NULL,
	[Nombre] [varchar](15) NOT NULL,
	[Numeros] [tinyint] NOT NULL,
	[Premio] [decimal](3, 1) NOT NULL,
 CONSTRAINT [PK_TiposApuesta] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[COL_Apuestas]  WITH CHECK ADD  CONSTRAINT [FK_Apuesta_Jugada] FOREIGN KEY([IDMesa], [IDJugada])
REFERENCES [dbo].[COL_Jugadas] ([IDMesa], [IDJugada])
GO
ALTER TABLE [dbo].[COL_Apuestas] CHECK CONSTRAINT [FK_Apuesta_Jugada]
GO
ALTER TABLE [dbo].[COL_Apuestas]  WITH CHECK ADD  CONSTRAINT [FK_Apuesta_Jugador] FOREIGN KEY([IDJugador])
REFERENCES [dbo].[COL_Jugadores] ([ID])
GO
ALTER TABLE [dbo].[COL_Apuestas] CHECK CONSTRAINT [FK_Apuesta_Jugador]
GO
ALTER TABLE [dbo].[COL_Apuestas]  WITH CHECK ADD  CONSTRAINT [FK_Apuesta_Tipo] FOREIGN KEY([Tipo])
REFERENCES [dbo].[COL_TiposApuesta] ([ID])
GO
ALTER TABLE [dbo].[COL_Apuestas] CHECK CONSTRAINT [FK_Apuesta_Tipo]
GO
ALTER TABLE [dbo].[COL_Jugadas]  WITH CHECK ADD  CONSTRAINT [FK_Jugada_Mesa] FOREIGN KEY([IDMesa])
REFERENCES [dbo].[COL_Mesas] ([ID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[COL_Jugadas] CHECK CONSTRAINT [FK_Jugada_Mesa]
GO
ALTER TABLE [dbo].[COL_NumerosApuesta]  WITH CHECK ADD  CONSTRAINT [FK_Numero_Apuesta] FOREIGN KEY([IDJugador], [IDMesa], [IDJugada])
REFERENCES [dbo].[COL_Apuestas] ([IDJugador], [IDMesa], [IDJugada])
GO
ALTER TABLE [dbo].[COL_NumerosApuesta] CHECK CONSTRAINT [FK_Numero_Apuesta]
GO
ALTER TABLE [dbo].[COL_Apuestas]  WITH CHECK ADD  CONSTRAINT [CK_ImportePositivo] CHECK  (([Importe]>(1)))
GO
ALTER TABLE [dbo].[COL_Apuestas] CHECK CONSTRAINT [CK_ImportePositivo]
GO
ALTER TABLE [dbo].[COL_Jugadas]  WITH CHECK ADD  CONSTRAINT [CK_NoVaMasTrasJugar] CHECK  (([MomentoJuega]<getdate() OR [NoVaMas]=(0)))
GO
ALTER TABLE [dbo].[COL_Jugadas] CHECK CONSTRAINT [CK_NoVaMasTrasJugar]
GO
ALTER TABLE [dbo].[COL_Jugadas]  WITH CHECK ADD  CONSTRAINT [CK_Numero] CHECK  (([Numero]>=(0) AND [Numero]<=(36)))
GO
ALTER TABLE [dbo].[COL_Jugadas] CHECK CONSTRAINT [CK_Numero]
GO
ALTER TABLE [dbo].[COL_Jugadas]  WITH CHECK ADD  CONSTRAINT [CK_NumeroDespues] CHECK  (([NovaMas]=(1) OR [Numero] IS NULL))
GO
ALTER TABLE [dbo].[COL_Jugadas] CHECK CONSTRAINT [CK_NumeroDespues]
GO
ALTER TABLE [dbo].[COL_Jugadores]  WITH CHECK ADD  CONSTRAINT [CK_MayorEdad] CHECK  (((year(getdate()-CAST([FechaNacimiento] AS SMALLDATETIME))-(1900))>=(18)))
GO
ALTER TABLE [dbo].[COL_Jugadores] CHECK CONSTRAINT [CK_MayorEdad]
GO
ALTER TABLE [dbo].[COL_NumerosApuesta]  WITH CHECK ADD  CONSTRAINT [CK_NumeroJ] CHECK  (([Numero]>=(0) AND [Numero]<=(36)))
GO
ALTER TABLE [dbo].[COL_NumerosApuesta] CHECK CONSTRAINT [CK_NumeroJ]
GO
USE master