USE [master]
GO
/****** Object:  Database [PruebaGalac]    Script Date: 23/2/2022 11:11:44 a. m. ******/
CREATE DATABASE [PruebaGalac]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'PruebaGalac', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\PruebaGalac.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'PruebaGalac_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL12.SQLEXPRESS\MSSQL\DATA\PruebaGalac_log.ldf' , SIZE = 2048KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [PruebaGalac] SET COMPATIBILITY_LEVEL = 120
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [PruebaGalac].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [PruebaGalac] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [PruebaGalac] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [PruebaGalac] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [PruebaGalac] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [PruebaGalac] SET ARITHABORT OFF 
GO
ALTER DATABASE [PruebaGalac] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [PruebaGalac] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [PruebaGalac] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [PruebaGalac] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [PruebaGalac] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [PruebaGalac] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [PruebaGalac] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [PruebaGalac] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [PruebaGalac] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [PruebaGalac] SET  DISABLE_BROKER 
GO
ALTER DATABASE [PruebaGalac] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [PruebaGalac] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [PruebaGalac] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [PruebaGalac] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [PruebaGalac] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [PruebaGalac] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [PruebaGalac] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [PruebaGalac] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [PruebaGalac] SET  MULTI_USER 
GO
ALTER DATABASE [PruebaGalac] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [PruebaGalac] SET DB_CHAINING OFF 
GO
ALTER DATABASE [PruebaGalac] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [PruebaGalac] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [PruebaGalac] SET DELAYED_DURABILITY = DISABLED 
GO
USE [PruebaGalac]
GO
/****** Object:  Table [dbo].[TB_LogLectura]    Script Date: 23/2/2022 11:11:44 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TB_LogLectura](
	[IdRegistro] [bigint] IDENTITY(1,1) NOT NULL,
	[Linea] [int] NOT NULL,
	[PalabrasEncontradas] [varchar](5000) NULL,
	[IdTipoEvento] [varchar](1) NOT NULL,
	[DescripcionEvento] [varchar](500) NOT NULL,
	[FechaCreacion] [datetime] NULL CONSTRAINT [DF_TB_TRNEventos1_FechaCreacion]  DEFAULT (getdate())
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  StoredProcedure [dbo].[SP_MostrarReg]    Script Date: 23/2/2022 11:11:44 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_MostrarReg]
AS
	SELECT LINEA,PALABRASENCONTRADAS FROM TB_LogLectura 
		WHERE CONVERT([varchar](10),FechaCreacion,(111)) =  CONVERT([varchar](10),getdate(),(111))
		AND Linea > 0


GO
/****** Object:  StoredProcedure [dbo].[SP_RegistrarEvento]    Script Date: 23/2/2022 11:11:44 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_RegistrarEvento]
	@Linea int,
	@PalabrasEncontradas varchar(5000), 
	@idTipoEvento varchar(1) , 
	@DescripcionEvento varchar(500)
AS
	INSERT INTO TB_LogLectura
	                         (Linea, PalabrasEncontradas,IdTipoEvento, DescripcionEvento)
	VALUES        (@Linea,substring(@PalabrasEncontradas,2,len(@PalabrasEncontradas)),@IdTipoEvento,UPPER(@DescripcionEvento));


GO
USE [master]
GO
ALTER DATABASE [PruebaGalac] SET  READ_WRITE 
GO
