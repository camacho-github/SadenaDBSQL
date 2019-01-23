USE SADENADB
select * from SDB.TAUSUARIO

begin tran
DECLARE
@po_msg_code INT,
@po_msg	VARCHAR(255)
EXEC SDB.PRNProcesaCargaSINAC @po_msg_code output, @po_msg output
EXEC SDB.PRNProcesaCargaSIC @po_msg_code output, @po_msg output
EXEC SDB.PRNProcesarDuplicadosSIC @po_msg_code output, @po_msg output
SELECT @po_msg_code, @po_msg
COMMIT TRAN


begin tran
DECLARE
@po_msg_code INT,
@po_msg	VARCHAR(255)
EXEC SDB.PRNSubregistroNacimientos @po_msg_code output, @po_msg output
SELECT @po_msg_code, @po_msg
COMMIT TRAN


begin tran
DECLARE
@po_msg_code INT,
@po_msg	VARCHAR(255)
EXEC SDB.PRNDepurarCargas @po_msg_code output, @po_msg output
SELECT @po_msg_code, @po_msg
COMMIT TRAN

begin tran
DECLARE
@po_msg_code INT,
@po_msg	VARCHAR(255)
EXEC SDB.PRSCatatalogosPreConsulta @po_msg_code output, @po_msg output
SELECT @po_msg_code, @po_msg
COMMIT TRAN

begin tran
DECLARE
@po_msg_code INT,
@po_msg	VARCHAR(255),
@pi_ano VARCHAR(255),
@pi_mes VARCHAR(255),
@pc_municipio VARCHAR(255)

set @pi_ano = '2018'
set @pi_mes = '1'

--EXEC SDB.PRNSubregistroTotalNacimientos @po_msg_code output, @po_msg output
EXEC SDB.PRNSubregistroNacimientosPorConsulta @pi_ano,@pi_mes,@pc_municipio, @po_msg_code output, @po_msg output
SELECT @po_msg_code, @po_msg
ROLLBACK TRAN


select count(*) from sdb.ctlocalidad