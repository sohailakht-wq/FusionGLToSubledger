select
main.LEDGER_ID,
main.LEDGER_NAME,
main.JE_SOURCE,
main.JE_SOURCE_NAME,
main.JE_CATEGORY,
main.JE_GATEGORY_NAME,
main.GL_batch_name,
main.JOURNAL_NAME,
main.JOURNAL_LINE_DESC,
main.je_header_id,				
main.JE_LINE_NUM,
main.period_name,
main.currency_code,
main.BATCH_STATUS,
main.JOURNAL_STATUS,
main.JE_LINE_STATUS,	
main.JOURNAL_DATE,
main.Posted_Date,
main.ACCOUNTED_DR,
main.ACCOUNTED_CR,
(NVL(main.ACCOUNTED_DR,0) - NVL(main.ACCOUNTED_CR,0)) ACCOUNTED_AMOUNT,
main.ENTERED_DR,
main.ENTERED_CR,
(NVL(main.ENTERED_DR,0) - NVL(main.ENTERED_CR,0)) ENTERED_AMOUNT,
main.GL_FUND,
main.GL_FUND_DESC,
main.GL_COST_CENTER,
main.GL_COST_CENTER_DESC,
main.GL_COST_TYPE,
main.GL_COST_TYPE_DESC,
main.GL_PROJECT,
main.GL_PROJECT_DESC,
main.GL_ACTIVITY_TYPE,
main.GL_ACTIVITY_TYPE_DESC,
main.GL_FERC,
main.GL_FERC_DESC,
main.GL_BUDGET_CODE,
main.GL_BUDGET_CODE_DESC,
main.GL_INTERCOMPANY,
main.GL_INTERCOMPANY_DESC,
main.GL_FUTURE1,
main.GL_FUTURE2,
main.reversed_je_header_id,
main.application_id,
main.ae_header_id,
main.ae_line_num,				
main.ACCOUNTING_CLASS_CODE,
main.XDL_TEMP_LINE_NUM, 
main.XDL_SOURCE_DIST_TYPE,
main.XDL_SOURCE_DIST_ID_NUM_1,
main.XDL_SOURCE_DIST_ID_NUM_2,
main.XDL_SOURCE_DIST_ID_CHAR_1,
main.XDL_REF_AE_HEADER_ID,
main.XLA_EVENT_ID,
main.XLA_EVENT_TYPE_CODE,
main.XTE_ENTITY_ID,
main.XTE_ENTITY_CODE,
main.XTE_SOURCE_ID_INT_1,
main.XTE_SOURCE_ID_INT_2,
main.XTE_SOURCE_ID_INT_3,
main.XTE_SOURCE_ID_CHAR_1,
main.XTE_SOURCE_ID_CHAR_2, 
main.XTE_TRANSACTION_NUMBER,
main.AR_CUSTOMER_NAME,    
main.AR_CUSTOMER_ACCOUNT,
main.AR_TRX_NUMBER,
main.AR_TRX_DATE,
main.AR_CASH_RCPT_NUM,
main.AR_CASH_RCPT_DATE,
main.SUPPLIER_NAME,
main.SUPPLIER_NUMBER,
main.PO_NUMBER,
main.PO_LINE_NUM,
main.PO_DIST_LINE_NUM,
main.INVOICE_NUM,
main.VOUCHER_NUM,
main.AP_INVOICE_SOURCE,
main.ORG_ID,
main.BU,
main.INVOICE_DATE,
main.INVOICE_LINE_NUM,
main.INVOICE_DIST_LINE_NUM,
main.PAYMENT_NUM,
main.RECEIPT_NUMBER,
main.TRANSACTION_ID,
main.ITEM_NUMBER,
main.ITEM_DESCRIPTION,
main.TRANSACTION_QUANTITY,
main.TRANSACTION_UOM,
main.project_number,
main.PROJECT_NAME,
main.TASK_NUMBER,
main.TASK_NAME,
main.EXPENDITURE_TYPE,
main.EXPENDITURE_TYPE_DESC,
main.EXPENDITURE_ORG_NAME,
main.CDL_LINE_NUM,
main.expenditure_comment,
main.PJC_TRANSACTION_SOURCE,
main.PJC_DOCUMENT_TYPE,
main.PJC_DOCUMENT_ENTRY, 
main.PJC_BATCH_NAME,
main.employee_number, 
main.employee_name,
main.OMS_Sales_Order,
main.OMS_Customer_PO,
main.source_code
FROM
(
-- Costing
SELECT 			GL.LEDGER_ID,
				GL.NAME LEDGER_NAME,
				GJH.JE_SOURCE,
				GJS.user_je_source_name JE_SOURCE_NAME,
				GJH.JE_CATEGORY,
				GJC.USER_JE_CATEGORY_NAME JE_GATEGORY_NAME,
				gjb.name GL_batch_name,
				GJH.NAME JOURNAL_NAME,
				GJl.DESCRIPTION JOURNAL_LINE_DESC,
				gjh.je_header_id,				
				GJL.JE_LINE_NUM,
				gjl.period_name,
				NVL(gjh.currency_code,GJL.currency_code) currency_code,
				DECODE (gjb.status,  'P', 'Posted',  'U', 'Unposted',  gjb.status) BATCH_STATUS,
				DECODE (gjh.status,  'P', 'Posted',  'U', 'Unposted',  gjh.status) JOURNAL_STATUS,
				DECODE (gjl.status,  'P', 'Posted',  'U', 'Unposted',  gjl.status) JE_LINE_STATUS,	
				to_char(gjh.default_effective_date,'MM/DD/YYYY HH24:MI:SS') JOURNAL_DATE,
				to_char(gjh.posted_date,'MM/DD/YYYY HH24:MI:SS')  Posted_Date,
				case when (xdl.ae_line_num IS NULL )
			THEN NVL(xal.accounted_dr,GJL.accounted_dr) 
			 ELSE xdl.unrounded_accounted_dr
			END ACCOUNTED_DR,
					case when (xdl.ae_line_num IS NULL )
				   THEN NVL(xal.accounted_cr,GJL.accounted_cr) 
			 ELSE xdl.unrounded_accounted_cr
			END ACCOUNTED_CR,
					case when (xdl.ae_line_num IS NULL )
				   THEN NVL(xal.entered_dr,GJL.entered_dr) 
			 ELSE xdl.unrounded_entered_dr
			END ENTERED_DR,
					case when (xdl.ae_line_num IS NULL )
				   THEN NVL(xal.entered_cr,GJL.entered_cr) 
			 ELSE xdl.unrounded_entered_cr
			END ENTERED_CR,
				gcc.segment1 GL_FUND,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,1, gcc.segment1) GL_FUND_DESC,
				GCC.SEGMENT2 GL_COST_CENTER,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,2, gcc.segment2) GL_COST_CENTER_DESC,
				GCC.SEGMENT3 GL_COST_TYPE,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,3, gcc.segment3) GL_COST_TYPE_DESC,
				GCC.SEGMENT4 GL_PROJECT,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,4, gcc.segment4) GL_PROJECT_DESC,
				GCC.SEGMENT5 GL_ACTIVITY_TYPE,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,5, gcc.segment5) GL_ACTIVITY_TYPE_DESC,
				GCC.SEGMENT6 GL_FERC,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,6, gcc.segment6) GL_FERC_DESC,
				GCC.SEGMENT7 GL_BUDGET_CODE,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,7, gcc.segment7) GL_BUDGET_CODE_DESC,
				GCC.SEGMENT8 GL_INTERCOMPANY,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,8, gcc.segment8) GL_INTERCOMPANY_DESC,
				GCC.SEGMENT9 GL_FUTURE1,
				GCC.SEGMENT10 GL_FUTURE2,
				GJH.reversed_je_header_id,
				xal.application_id,
				xah.ae_header_id,
				xal.ae_line_num,				
				xal.ACCOUNTING_CLASS_CODE,
				XDL.TEMP_LINE_NUM XDL_TEMP_LINE_NUM, 
				XDL.SOURCE_DISTRIBUTION_TYPE XDL_SOURCE_DIST_TYPE,
				XDL.SOURCE_DISTRIBUTION_ID_NUM_1 XDL_SOURCE_DIST_ID_NUM_1,
				XDL.SOURCE_DISTRIBUTION_ID_NUM_2 XDL_SOURCE_DIST_ID_NUM_2,
				XDL.SOURCE_DISTRIBUTION_ID_CHAR_1 XDL_SOURCE_DIST_ID_CHAR_1,
				XDL.ref_ae_header_id XDL_REF_AE_HEADER_ID,
				XE.event_id XLA_EVENT_ID,
				XE.event_type_code XLA_EVENT_TYPE_CODE,
				xte.entity_ID XTE_ENTITY_ID,
				xte.entity_code XTE_ENTITY_CODE,
				XTE.SOURCE_ID_INT_1 XTE_SOURCE_ID_INT_1,
				XTE.SOURCE_ID_INT_2 XTE_SOURCE_ID_INT_2,
				XTE.SOURCE_ID_INT_3 XTE_SOURCE_ID_INT_3,
				XTE.source_id_char_1 XTE_SOURCE_ID_CHAR_1,
				XTE.source_id_char_2 XTE_SOURCE_ID_CHAR_2, 
				XTE.transaction_number XTE_TRANSACTION_NUMBER,
				NULL AR_CUSTOMER_NAME,    
				NULL AR_CUSTOMER_ACCOUNT,
				NULL AR_TRX_NUMBER,
				NULL AR_TRX_DATE,
				NULL AR_CASH_RCPT_NUM,
				NULL AR_CASH_RCPT_DATE,
				NULL SUPPLIER_NAME,
				NULL SUPPLIER_NUMBER,
				NULL PO_NUMBER,
				NULL PO_LINE_NUM,
				NULL PO_DIST_LINE_NUM,
				NULL INVOICE_NUM,
				NULL VOUCHER_NUM,
				NULL AP_INVOICE_SOURCE,
				NULL ORG_ID,
				NULL BU,
				NULL INVOICE_DATE,
				NULL INVOICE_LINE_NUM,
				NULL INVOICE_DIST_LINE_NUM,
				NULL PAYMENT_NUM,
				NULL RECEIPT_NUMBER,
				IMT.TRANSACTION_ID TRANSACTION_ID,
				ESI.ITEM_NUMBER ITEM_NUMBER,
				ESI.DESCRIPTION ITEM_DESCRIPTION,
                IMT.TRANSACTION_QUANTITY,
				IMT.TRANSACTION_UOM,
				PPV.SEGMENT1 project_number,
                PPV.NAME PROJECT_NAME,
                TO_CHAR(PPE.ELEMENT_NUMBER) AS TASK_NUMBER,
				PPE.NAME TASK_NAME,
				PET.EXPENDITURE_TYPE_NAME AS EXPENDITURE_TYPE,
				NULL EXPENDITURE_TYPE_DESC,
		        hou.name EXPENDITURE_ORG_NAME,
				NULL CDL_LINE_NUM,
				NULL expenditure_comment,
				NULL PJC_TRANSACTION_SOURCE,
				NULL PJC_DOCUMENT_TYPE,
				NULL PJC_DOCUMENT_ENTRY, 
				NULL PJC_BATCH_NAME,
				NULL employee_number, 
				NULL employee_name,
				IMT.attribute1 OMS_Sales_Order,
				CASE WHEN IMT.source_code IN ('WIP Completion','WIP Backflush') THEN
				IMT.TRANSACTION_SOURCE_NAME
				ELSE 
				IMT.attribute2 
				END OMS_Customer_PO,
				IMT.source_code
FROM 		gl_je_lines gjl
			,gl_je_headers gjh
			,gl_je_batches gjb   
			,gl_import_references gir
			,xla_ae_lines xal
			,xla_ae_headers xah
			,xla_distribution_links xdl
			,xla_events xe
			,xla_transaction_entities xte			
			,CST_COST_DISTRIBUTIONS ccd
			,CST_TRANSACTIONS CT
			,CST_INV_TRANSACTIONS CIT
			,INV_MATERIAL_TXNS IMT
			,INV_TRANSACTION_TYPES_TL ITT
			,INV_ORG_PARAMETERS IOP
			,EGP_SYSTEM_ITEMS_VL ESI
			,GL_CODE_COMBINATIONS GCC
			,gl_je_sources GJS
			,gl_je_categories GJC
			,gl_ledgers gl
			,PJF_PROJECTS_ALL_VL PPV
            ,PJF_PROJ_ELEMENTS_VL PPE
            ,PJF_EXP_TYPES_TL PET
			,HR_ORGANIZATION_UNITS hou
	WHERE 1=1
			and gjh.ledger_id    = gl.ledger_id
			and gjb.je_batch_id  = gjh.je_batch_id
			and gjh.je_header_id = gjl.je_header_id 
			and gjh.je_source    = gjs.je_source_name
			and gjh.je_category  = gjc.je_category_name
			and gjl.je_header_id = gir.je_header_id
			and gjl.je_line_num  = gir.je_line_num
			and gir.gl_sl_link_table = xal.gl_sl_link_table
			and gir.gl_sl_link_id    = xal.gl_sl_link_id
			and xal.application_id = xah.application_id
			and xal.ae_header_id   = xah.ae_header_id
			and xah.application_id = xe.application_id
			and xah.event_id       = xe.event_id 
			and xah.ae_header_id = xdl.ae_header_id(+)
			and xal.ae_line_num = xdl.ae_line_num(+)
			and xe.application_id = xte.application_id
			and xe.entity_id      = xte.entity_id
			and GJH.JE_SOURCE = 'Cost Accounting'
			and xte.source_id_int_1   = ccd.distribution_id(+)
			AND CCD.TRANSACTION_ID = CT.TRANSACTION_ID(+)
			AND CT.CST_INV_TRANSACTION_ID = CIT.CST_INV_TRANSACTION_ID(+)
			AND CIT.EXTERNAL_SYSTEM_REF_ID = IMT.TRANSACTION_ID(+)
			AND IMT.TRANSACTION_TYPE_ID = ITT.TRANSACTION_TYPE_ID(+)
			AND IMT.ORGANIZATION_ID = IOP.ORGANIZATION_ID (+)
			AND IMT.INVENTORY_ITEM_ID = ESI.INVENTORY_ITEM_ID(+)
			AND IMT.ORGANIZATION_ID = ESI.INVENTORY_ORGANIZATION_ID(+)
			and gjl.code_combination_id = gcc.code_combination_id
			and CIT.PJC_EXPENDITURE_TYPE_ID = PET.EXPENDITURE_TYPE_ID(+)			
			and CIT.PJC_PROJECT_ID	= PPV.PROJECT_ID(+)
			and CIT.PJC_TASK_ID		= PPE.PROJ_ELEMENT_ID(+)
			and CIT.PJC_ORGANIZATION_ID = hou.organization_id(+)
			and gjh.actual_flag = 'A'
			AND (GJH.STATUS IN (:P_POSTING_STATUS) OR COALESCE(:P_POSTING_STATUS,null) IS NULL)
		    AND	(gjh.PERIOD_NAME IN (:P_PERIOD_NAME) OR COALESCE(:P_PERIOD_NAME,null) IS NULL)
			AND GL.NAME  = :P_LEDGER_NAME
			--Allow Multiselect on the following parameters
			AND	(GCC.SEGMENT1 IN (:P_FUND) OR COALESCE(:P_FUND,null) IS NULL)
			AND	(GCC.SEGMENT2 IN (:P_COST_CENTER) OR COALESCE(:P_COST_CENTER,null) IS NULL)
			AND	(GCC.SEGMENT3 IN (:P_COST_TYPE) OR COALESCE(:P_COST_TYPE,null) IS NULL)
			AND	(GCC.SEGMENT4 IN (:P_PROJECT) OR COALESCE(:P_PROJECT,null) IS NULL)
			AND	(GCC.SEGMENT5 IN (:P_ACTIVITY_TYPE) OR COALESCE(:P_ACTIVITY_TYPE,null) IS NULL)
			AND	(GCC.SEGMENT6 IN (:P_FERC) OR COALESCE(:P_FERC,null) IS NULL)
			AND	(GCC.SEGMENT7 IN (:P_BUDGET_CODE) OR COALESCE(:P_BUDGET_CODE,null) IS NULL)
			AND	(GCC.SEGMENT8 IN (:P_INTERCO) OR COALESCE(:P_INTERCO,null) IS NULL)
			AND	(GJS.user_je_source_name IN (:P_JE_SOURCE_NAME) OR COALESCE(:P_JE_SOURCE_NAME,null) IS NULL)
			AND	(GJC.USER_JE_CATEGORY_NAME IN (:P_JE_CATEGORY_NAME) OR COALESCE(:P_JE_CATEGORY_NAME,null) IS NULL)
UNION			
--Receipt Accounting
SELECT 			GL.LEDGER_ID,
				GL.NAME LEDGER_NAME,
				GJH.JE_SOURCE,
				GJS.user_je_source_name JE_SOURCE_NAME,
				GJH.JE_CATEGORY,
				GJC.USER_JE_CATEGORY_NAME JE_GATEGORY_NAME,
				gjb.name GL_batch_name,
				GJH.NAME JOURNAL_NAME,
				GJl.DESCRIPTION JOURNAL_LINE_DESC,
				gjh.je_header_id,				
				GJL.JE_LINE_NUM,
				gjl.period_name,
				NVL(gjh.currency_code,GJL.currency_code) currency_code,
				DECODE (gjb.status,  'P', 'Posted',  'U', 'Unposted',  gjb.status) BATCH_STATUS,
				DECODE (gjh.status,  'P', 'Posted',  'U', 'Unposted',  gjh.status) JOURNAL_STATUS,
				DECODE (gjl.status,  'P', 'Posted',  'U', 'Unposted',  gjl.status) JE_LINE_STATUS,	
				to_char(gjh.default_effective_date,'MM/DD/YYYY HH24:MI:SS') JOURNAL_DATE,
				to_char(gjh.posted_date,'MM/DD/YYYY HH24:MI:SS')  Posted_Date,
				case when (xdl.ae_line_num IS NULL )
			THEN NVL(xal.accounted_dr,GJL.accounted_dr) 
			 ELSE xdl.unrounded_accounted_dr
			END ACCOUNTED_DR,
					case when (xdl.ae_line_num IS NULL )
				   THEN NVL(xal.accounted_cr,GJL.accounted_cr) 
			 ELSE xdl.unrounded_accounted_cr
			END ACCOUNTED_CR,
					case when (xdl.ae_line_num IS NULL )
				   THEN NVL(xal.entered_dr,GJL.entered_dr) 
			 ELSE xdl.unrounded_entered_dr
			END ENTERED_DR,
					case when (xdl.ae_line_num IS NULL )
				   THEN NVL(xal.entered_cr,GJL.entered_cr) 
			 ELSE xdl.unrounded_entered_cr
			END ENTERED_CR,
				gcc.segment1 GL_FUND,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,1, gcc.segment1) GL_FUND_DESC,
				GCC.SEGMENT2 GL_COST_CENTER,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,2, gcc.segment2) GL_COST_CENTER_DESC,
				GCC.SEGMENT3 GL_COST_TYPE,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,3, gcc.segment3) GL_COST_TYPE_DESC,
				GCC.SEGMENT4 GL_PROJECT,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,4, gcc.segment4) GL_PROJECT_DESC,
				GCC.SEGMENT5 GL_ACTIVITY_TYPE,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,5, gcc.segment5) GL_ACTIVITY_TYPE_DESC,
				GCC.SEGMENT6 GL_FERC,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,6, gcc.segment6) GL_FERC_DESC,
				GCC.SEGMENT7 GL_BUDGET_CODE,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,7, gcc.segment7) GL_BUDGET_CODE_DESC,
				GCC.SEGMENT8 GL_INTERCOMPANY,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,8, gcc.segment8) GL_INTERCOMPANY_DESC,
				GCC.SEGMENT9 GL_FUTURE1,
				GCC.SEGMENT10 GL_FUTURE2,				
				GJH.reversed_je_header_id,
				xal.application_id,
				xah.ae_header_id,
				xal.ae_line_num,				
				xal.ACCOUNTING_CLASS_CODE,
				XDL.TEMP_LINE_NUM XDL_TEMP_LINE_NUM, 
				XDL.SOURCE_DISTRIBUTION_TYPE XDL_SOURCE_DIST_TYPE,
				XDL.SOURCE_DISTRIBUTION_ID_NUM_1 XDL_SOURCE_DIST_ID_NUM_1,
				XDL.SOURCE_DISTRIBUTION_ID_NUM_2 XDL_SOURCE_DIST_ID_NUM_2,
				XDL.SOURCE_DISTRIBUTION_ID_CHAR_1 XDL_SOURCE_DIST_ID_CHAR_1,
				XDL.ref_ae_header_id XDL_REF_AE_HEADER_ID,
				XE.event_id XLA_EVENT_ID,
				XE.event_type_code XLA_EVENT_TYPE_CODE,
				xte.entity_ID XTE_ENTITY_ID,
				xte.entity_code XTE_ENTITY_CODE,
				XTE.SOURCE_ID_INT_1 XTE_SOURCE_ID_INT_1,
				XTE.SOURCE_ID_INT_2 XTE_SOURCE_ID_INT_2,
				XTE.SOURCE_ID_INT_3 XTE_SOURCE_ID_INT_3,
				XTE.source_id_char_1 XTE_SOURCE_ID_CHAR_1,
				XTE.source_id_char_2 XTE_SOURCE_ID_CHAR_2, 
				XTE.transaction_number XTE_TRANSACTION_NUMBER,
				NULL AR_CUSTOMER_NAME,    
				NULL AR_CUSTOMER_ACCOUNT,
				NULL AR_TRX_NUMBER,
				NULL AR_TRX_DATE,
				NULL AR_CASH_RCPT_NUM,
				NULL AR_CASH_RCPT_DATE,
				coalesce(HP1.PARTY_NAME,hp.party_name,null) SUPPLIER_NAME,
				ps.segment1 SUPPLIER_NUMBER,
				coalesce(CRAP.po_number,DECODE(CRE.EVENT_SOURCE,'PO',cre.source_doc_number,NULL),null) PO_NUMBER,
				(select line_num from po_lines_all where po_line_id=plla.po_line_id) PO_LINE_NUM,
				NULL PO_DIST_LINE_NUM,
				NULL INVOICE_NUM,
				NULL VOUCHER_NUM,
				NULL AP_INVOICE_SOURCE,
				iop.business_unit_id ORG_ID,
				hou.name BU,
				NULL INVOICE_DATE,
				NULL INVOICE_LINE_NUM,
				NULL INVOICE_DIST_LINE_NUM,
				NULL PAYMENT_NUM,
				NVL(CRT.receipt_number,RSH.receipt_num) RECEIPT_NUMBER,
				NVL(RCV.transaction_id,crt.cmr_rcv_transaction_id) TRANSACTION_ID,
				CASE WHEN (SELECT MIN(ITEM_NUMBER) from EGP_SYSTEM_ITEMS_V where INVENTORY_ITEM_ID = PLA.ITEM_ID and ORGANIZATION_ID = MASTER_ORG_ID) IS NOT NULL
				THEN (SELECT MIN(ITEM_NUMBER) from EGP_SYSTEM_ITEMS_V where INVENTORY_ITEM_ID = PLA.ITEM_ID and ORGANIZATION_ID = MASTER_ORG_ID)
				ELSE ESI.ITEM_NUMBER
				END ITEM_NUMBER,
				COALESCE(CRAP.ITEM_DESCRIPTION,PLA.item_description,ESI.description) ITEM_DESCRIPTION,
				RCV.quantity TRANSACTION_QUANTITY,
				RCV.uom_code TRANSACTION_UOM,   
				NULL project_number,
				NULL project_name,
				NULL task_number,
				NULL task_name,
				NULL expenditure_type,
				NULL EXPENDITURE_TYPE_DESC,
				NULL EXPENDITURE_ORG_NAME,
				NULL CDL_LINE_NUM,
				NULL expenditure_comment,
				NULL PJC_TRANSACTION_SOURCE,
				NULL PJC_DOCUMENT_TYPE,
				NULL PJC_DOCUMENT_ENTRY, 
				NULL PJC_BATCH_NAME,
				NULL employee_number, 
				NULL employee_name,
				NULL OMS_Sales_Order,
				NULL OMS_Customer_PO,
				NULL source_code				
FROM 		 gl_je_lines gjl
			,gl_je_headers gjh
			,gl_je_batches gjb   
			,gl_import_references gir
			,xla_ae_lines xal
			,xla_ae_headers xah
			,xla_distribution_links xdl
			,xla_events xe
			,xla_transaction_entities xte
			,cmr_rcv_events cre
			,egp_system_items_V esi
			--,egp_system_items_b esib
			--,CMR_AP_INVOICE_DTLS CAID
			,cmr_rcv_transactions crt
			,CMR_R_ACTIVE_PURCHASE_ORDDTL_V CRAP
			,rcv_transactions RCV
			,inv_org_parameters_v iop
			,hr_operating_units HOU
			,RCV_SHIPMENT_HEADERS RSH
			,po_line_locations_all plla
			,PO_LINES_ALL PLA
			,po_headers_all pha
			,poz_suppliers ps
			,hz_parties hp
			,poz_suppliers ps1
			,hz_parties hp1
			,GL_CODE_COMBINATIONS GCC
			,gl_je_sources GJS
			,gl_je_categories GJC
			,gl_ledgers gl
WHERE 1=1
			and gjh.ledger_id = gl.ledger_id
			and gjb.je_batch_id  = gjh.je_batch_id
			and gjh.je_header_id = gjl.je_header_id 
			and gjh.je_source    = gjs.je_source_name
			and gjh.je_category  = gjc.je_category_name
			and gjl.je_header_id = gir.je_header_id
			and gjl.je_line_num  = gir.je_line_num
			and gir.gl_sl_link_table = xal.gl_sl_link_table
			and gir.gl_sl_link_id    = xal.gl_sl_link_id
			and xal.application_id = xah.application_id
			and xal.ae_header_id   = xah.ae_header_id
			and xah.application_id = xe.application_id
			and xah.event_id       = xe.event_id 
			and xah.ae_header_id = xdl.ae_header_id(+)
			and xal.ae_line_num = xdl.ae_line_num(+)
			and xe.application_id = xte.application_id
			and xe.entity_id      = xte.entity_id
			and xte.ledger_id    = gl.ledger_id
			and gjh.je_source  ='Receipt Accounting'
			and xte.source_id_int_1 = cre.accounting_event_id
			--AND CRE.event_transaction_id = CAID.cmr_ap_invoice_dist_id(+)       
			--AND CAID.rcv_transaction_id = RCV.transaction_id(+)	
			AND CRE.inventory_item_id = ESI.inventory_item_id(+)
			AND CRE.inventory_org_id = ESI.organization_id(+)
			AND CRE.CMR_PO_DISTRIBUTION_ID = CRAP.CMR_PO_DISTRIBUTION_ID(+)			
			and cre.cmr_rcv_transaction_id = crt.cmr_rcv_transaction_id(+)
			AND CRT.EXTERNAL_SYSTEM_REF_ID = RCV.TRANSACTION_ID(+)
			AND RCV.organization_id = iop.organization_id(+)
			and iop.business_unit_id = hou.organization_id (+)
			AND RCV.shipment_header_id  = RSH.shipment_header_id(+)
			and crt.po_line_location_id = plla.line_location_id(+)
			AND RCV.po_line_id = PLA.po_line_id(+)
			and plla.po_header_id = pha.po_header_id(+)
			and pha.vendor_id = ps.vendor_id(+)
			and ps.party_id = hp.party_id (+)
			AND CRAP.vendor_id = PS1.vendor_id(+)
			AND PS1.party_id = HP1.party_id(+)
			and gjl.code_combination_id = gcc.code_combination_id  
			and gjh.actual_flag = 'A'
			AND (GJH.STATUS IN (:P_POSTING_STATUS) OR COALESCE(:P_POSTING_STATUS,null) IS NULL)
		  AND	(gjh.PERIOD_NAME IN (:P_PERIOD_NAME) OR COALESCE(:P_PERIOD_NAME,null) IS NULL)
			AND GL.NAME  = :P_LEDGER_NAME
			--Allow Multiselect on the following parameters
			AND	(GCC.SEGMENT1 IN (:P_FUND) OR COALESCE(:P_FUND,null) IS NULL)
			AND	(GCC.SEGMENT2 IN (:P_COST_CENTER) OR COALESCE(:P_COST_CENTER,null) IS NULL)
			AND	(GCC.SEGMENT3 IN (:P_COST_TYPE) OR COALESCE(:P_COST_TYPE,null) IS NULL)
			AND	(GCC.SEGMENT4 IN (:P_PROJECT) OR COALESCE(:P_PROJECT,null) IS NULL)
			AND	(GCC.SEGMENT5 IN (:P_ACTIVITY_TYPE) OR COALESCE(:P_ACTIVITY_TYPE,null) IS NULL)
			AND	(GCC.SEGMENT6 IN (:P_FERC) OR COALESCE(:P_FERC,null) IS NULL)
			AND	(GCC.SEGMENT7 IN (:P_BUDGET_CODE) OR COALESCE(:P_BUDGET_CODE,null) IS NULL)
			AND	(GCC.SEGMENT8 IN (:P_INTERCO) OR COALESCE(:P_INTERCO,null) IS NULL)			
			AND	(GJS.user_je_source_name IN (:P_JE_SOURCE_NAME) OR COALESCE(:P_JE_SOURCE_NAME,null) IS NULL)
			AND	(GJC.USER_JE_CATEGORY_NAME IN (:P_JE_CATEGORY_NAME) OR COALESCE(:P_JE_CATEGORY_NAME,null) IS NULL)		
UNION
-- Receivables
SELECT 			GL.LEDGER_ID,
				GL.NAME LEDGER_NAME,
				GJH.JE_SOURCE,
				GJS.user_je_source_name JE_SOURCE_NAME,
				GJH.JE_CATEGORY,
				GJC.USER_JE_CATEGORY_NAME JE_GATEGORY_NAME,
				gjb.name GL_batch_name,
				GJH.NAME JOURNAL_NAME,
				GJl.DESCRIPTION JOURNAL_LINE_DESC,
				gjh.je_header_id,				
				GJL.JE_LINE_NUM,
				gjl.period_name,
				NVL(gjh.currency_code,GJL.currency_code) currency_code,
				DECODE (gjb.status,  'P', 'Posted',  'U', 'Unposted',  gjb.status) BATCH_STATUS,
				DECODE (gjh.status,  'P', 'Posted',  'U', 'Unposted',  gjh.status) JOURNAL_STATUS,
				DECODE (gjl.status,  'P', 'Posted',  'U', 'Unposted',  gjl.status) JE_LINE_STATUS,	
				to_char(gjh.default_effective_date,'MM/DD/YYYY HH24:MI:SS') JOURNAL_DATE,
				to_char(gjh.posted_date,'MM/DD/YYYY HH24:MI:SS')  Posted_Date,
				case when (xdl.ae_line_num IS NULL )
			THEN NVL(xal.accounted_dr,GJL.accounted_dr) 
			 ELSE xdl.unrounded_accounted_dr
			END ACCOUNTED_DR,
					case when (xdl.ae_line_num IS NULL )
				   THEN NVL(xal.accounted_cr,GJL.accounted_cr) 
			 ELSE xdl.unrounded_accounted_cr
			END ACCOUNTED_CR,
					case when (xdl.ae_line_num IS NULL )
				   THEN NVL(xal.entered_dr,GJL.entered_dr) 
			 ELSE xdl.unrounded_entered_dr
			END ENTERED_DR,
					case when (xdl.ae_line_num IS NULL )
				   THEN NVL(xal.entered_cr,GJL.entered_cr) 
			 ELSE xdl.unrounded_entered_cr
			END ENTERED_CR,
				gcc.segment1 GL_FUND,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,1, gcc.segment1) GL_FUND_DESC,
				GCC.SEGMENT2 GL_COST_CENTER,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,2, gcc.segment2) GL_COST_CENTER_DESC,
				GCC.SEGMENT3 GL_COST_TYPE,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,3, gcc.segment3) GL_COST_TYPE_DESC,
				GCC.SEGMENT4 GL_PROJECT,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,4, gcc.segment4) GL_PROJECT_DESC,
				GCC.SEGMENT5 GL_ACTIVITY_TYPE,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,5, gcc.segment5) GL_ACTIVITY_TYPE_DESC,
				GCC.SEGMENT6 GL_FERC,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,6, gcc.segment6) GL_FERC_DESC,
				GCC.SEGMENT7 GL_BUDGET_CODE,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,7, gcc.segment7) GL_BUDGET_CODE_DESC,
				GCC.SEGMENT8 GL_INTERCOMPANY,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,8, gcc.segment8) GL_INTERCOMPANY_DESC,
				GCC.SEGMENT9 GL_FUTURE1,
				GCC.SEGMENT10 GL_FUTURE2,				
				GJH.reversed_je_header_id,
				xal.application_id,
				xah.ae_header_id,
				xal.ae_line_num,				
				xal.ACCOUNTING_CLASS_CODE,
				XDL.TEMP_LINE_NUM XDL_TEMP_LINE_NUM, 
				XDL.SOURCE_DISTRIBUTION_TYPE XDL_SOURCE_DIST_TYPE,
				XDL.SOURCE_DISTRIBUTION_ID_NUM_1 XDL_SOURCE_DIST_ID_NUM_1,
				XDL.SOURCE_DISTRIBUTION_ID_NUM_2 XDL_SOURCE_DIST_ID_NUM_2,
				XDL.SOURCE_DISTRIBUTION_ID_CHAR_1 XDL_SOURCE_DIST_ID_CHAR_1,
				XDL.ref_ae_header_id XDL_REF_AE_HEADER_ID,
				XE.event_id XLA_EVENT_ID,
				XE.event_type_code XLA_EVENT_TYPE_CODE,
				xte.entity_ID XTE_ENTITY_ID,
				xte.entity_code XTE_ENTITY_CODE,
				XTE.SOURCE_ID_INT_1 XTE_SOURCE_ID_INT_1,
				XTE.SOURCE_ID_INT_2 XTE_SOURCE_ID_INT_2,
				XTE.SOURCE_ID_INT_3 XTE_SOURCE_ID_INT_3,
				XTE.source_id_char_1 XTE_SOURCE_ID_CHAR_1,
				XTE.source_id_char_2 XTE_SOURCE_ID_CHAR_2, 
				XTE.transaction_number XTE_TRANSACTION_NUMBER,
				hp.party_name AR_CUSTOMER_NAME,    
				HCA.ACCOUNT_NUMBER AR_CUSTOMER_ACCOUNT,
				rcta.trx_number AR_TRX_NUMBER,
				to_char(rcta.trx_date,'MM/DD/YYYY') AR_TRX_DATE,
				NULL AR_CASH_RCPT_NUM,
				NULL AR_CASH_RCPT_DATE,
				NULL SUPPLIER_NAME,
				NULL SUPPLIER_NUMBER,
				NULL PO_NUMBER,
				NULL PO_LINE_NUM,
				NULL PO_DIST_LINE_NUM,
				NULL INVOICE_NUM,
				NULL VOUCHER_NUM,
				NULL AP_INVOICE_SOURCE,
				RCTA.org_id ORG_ID,
				HOU.NAME BU,
				NULL INVOICE_DATE,
				NULL INVOICE_LINE_NUM,
				NULL INVOICE_DIST_LINE_NUM,
				NULL PAYMENT_NUM,
				NULL RECEIPT_NUMBER,
				NULL TRANSACTION_ID,	
				xdll.ITEM_NUMBER ITEM_NUMBER,
				NVL(xdll.DESCRIPTION,xdll.LINE_DESCRIPTION) ITEM_DESCRIPTION,	
				xdll.QUANTITY_INVOICED TRANSACTION_QUANTITY,
				xdll.UOM_CODE TRANSACTION_UOM,
				NULL project_number,
				NULL project_name,
				NULL task_number,
				NULL task_name,
				NULL expenditure_type,
				NULL EXPENDITURE_TYPE_DESC,
				NULL EXPENDITURE_ORG_NAME,
				NULL CDL_LINE_NUM,
				NULL expenditure_comment,
				NULL PJC_TRANSACTION_SOURCE,
				NULL PJC_DOCUMENT_TYPE,
				NULL PJC_DOCUMENT_ENTRY, 
				NULL PJC_BATCH_NAME,
				NULL employee_number, 
				NULL employee_name,
				rcta.attribute1 OMS_Sales_Order,
				xdll.attribute3 OMS_Customer_PO,
				NULL source_code
FROM 	gl_je_lines gjl,
		gl_je_headers gjh,
		gl_je_batches gjb,    
		gl_import_references gir,
		xla_ae_lines xal,
		xla_ae_headers xah,
		xla_distribution_links xdl,
		xla_events xe,
		xla_transaction_entities xte,
		ra_customer_trx_all rcta
		,hr_operating_units HOU
		,HZ_CUST_ACCOUNTS HCA
		,hz_parties hp
		,GL_CODE_COMBINATIONS GCC
		,gl_je_categories gjc
		,gl_je_sources gjs
		,gl_ledgers gl
		,(select  rcta.trx_number,
        xdl.source_distribution_ID_num_1,
		ESIB.ITEM_NUMBER, 
		RCTLA.DESCRIPTION LINE_DESCRIPTION, 
        ESIB.PRIMARY_UOM_CODE,
		ESIT.DESCRIPTION,
		rctla.QUANTITY_INVOICED,
		RCTLA.UOM_CODE,
		rctla.attribute3
 FROM xla_transaction_entities xte,
         xla_ae_headers xah,
         xla_ae_lines xal,
		 xla_distribution_links xdl,
         gl_import_references gir,
         gl_je_lines gjl,
         gl_je_headers gjh,
		 gl_je_batches gjb,
         gl_code_combinations gcc,
         gl_ledgers gl,
	     ra_customer_trx_all rcta,		
         ra_customer_trx_lines_all rctla,
         ra_cust_trx_line_GL_dist_all rctld,
		 EGP_SYSTEM_ITEMS_B ESIB,
		 EGP_SYSTEM_ITEMS_TL ESIT
   WHERE 1 = 1
     AND xte.entity_code in ('TRANSACTIONS') 
     and  rctld.CUST_TRX_LINE_GL_DIST_ID = xdl.source_distribution_ID_num_1
     and rctld.CUSTOMER_TRX_LINE_ID = rctla.customer_trx_line_id 
	 AND RCTLA.INVENTORY_ITEM_ID 	 = ESIB.INVENTORY_ITEM_ID (+)
	 AND ESIB.inventory_item_id = ESIT.inventory_item_id
     AND xte.entity_id = xah.entity_id
	 and xte.ledger_id = gl.ledger_id
     AND xah.ae_header_id = xal.ae_header_id
     AND xal.gl_sl_link_id = gir.gl_sl_link_id
     AND xal.gl_sl_link_table = gir.gl_sl_link_table
	 and xah.ae_header_id = xdl.ae_header_id
	 and xal.ae_line_num = xdl.ae_line_num
     AND gir.je_header_id = gjl.je_header_id
     AND gir.je_line_num = gjl.je_line_num
     AND gjl.je_header_id = gjh.je_header_id
	 and gjb.je_source = 'Receivables'
	 and gjb.je_batch_id = gjh.je_batch_id
	 and gjl.code_combination_id = gcc.code_combination_id
	 and gjh.ledger_id = gl.ledger_id
	 and xte.source_id_int_1 = rcta.customer_trx_id
		) xdll
WHERE 1=1
		and gjh.ledger_id = gl.ledger_id
		and gjb.je_batch_id  = gjh.je_batch_id
		and gjl.je_header_id = gjh.je_header_id
		and gjh.je_source    = gjs.je_source_name
		and gjh.je_category  = gjc.je_category_name
		and gjl.je_header_id = gir.je_header_id
		and gjl.je_line_num  = gir.je_line_num
		and gir.gl_sl_link_table = xal.gl_sl_link_table
		and gir.gl_sl_link_id    = xal.gl_sl_link_id
		and xal.application_id = xah.application_id
		and xal.ae_header_id   = xah.ae_header_id
		and xah.application_id = xe.application_id
		and xah.ae_header_id = xdl.ae_header_id(+)
		and xal.ae_line_num = xdl.ae_line_num(+)
		and xdl.source_distribution_ID_num_1 = xdll.source_distribution_ID_num_1 (+)
		and xah.event_id       = xe.event_id 
		and xe.application_id = xte.application_id
		and xe.entity_id      = xte.entity_id
		and xte.application_id    = 222
		and xte.entity_code       = 'TRANSACTIONS'
		and xte.source_id_int_1   = rcta.customer_trx_id(+)
		AND RCTA.BILL_TO_CUSTOMER_ID = HCA.CUST_ACCOUNT_ID(+)
		AND RCTA.ORG_ID = HOU.ORGANIZATION_ID(+)
		AND HCA.PARTY_ID = HP.PARTY_ID(+)
		and gjl.code_combination_id = gcc.code_combination_id 
		and gjh.actual_flag = 'A'		
		AND (GJH.STATUS IN (:P_POSTING_STATUS) OR COALESCE(:P_POSTING_STATUS,null) IS NULL)
		AND	(gjh.PERIOD_NAME IN (:P_PERIOD_NAME) OR COALESCE(:P_PERIOD_NAME,null) IS NULL)
		AND GL.NAME  = :P_LEDGER_NAME
		--Allow Multiselect on the following parameters
		AND	(GCC.SEGMENT1 IN (:P_FUND) OR COALESCE(:P_FUND,null) IS NULL)
		AND	(GCC.SEGMENT2 IN (:P_COST_CENTER) OR COALESCE(:P_COST_CENTER,null) IS NULL)
		AND	(GCC.SEGMENT3 IN (:P_COST_TYPE) OR COALESCE(:P_COST_TYPE,null) IS NULL)
		AND	(GCC.SEGMENT4 IN (:P_PROJECT) OR COALESCE(:P_PROJECT,null) IS NULL)
		AND	(GCC.SEGMENT5 IN (:P_ACTIVITY_TYPE) OR COALESCE(:P_ACTIVITY_TYPE,null) IS NULL)
		AND	(GCC.SEGMENT6 IN (:P_FERC) OR COALESCE(:P_FERC,null) IS NULL)
		AND	(GCC.SEGMENT7 IN (:P_BUDGET_CODE) OR COALESCE(:P_BUDGET_CODE,null) IS NULL)
		AND	(GCC.SEGMENT8 IN (:P_INTERCO) OR COALESCE(:P_INTERCO,null) IS NULL)		
		AND	(GJS.user_je_source_name IN (:P_JE_SOURCE_NAME) OR COALESCE(:P_JE_SOURCE_NAME,null) IS NULL)
		AND	(GJC.USER_JE_CATEGORY_NAME IN (:P_JE_CATEGORY_NAME) OR COALESCE(:P_JE_CATEGORY_NAME,null) IS NULL)
UNION
-- Receivables adjustment
SELECT 			GL.LEDGER_ID,
				GL.NAME LEDGER_NAME,
				GJH.JE_SOURCE,
				GJS.user_je_source_name JE_SOURCE_NAME,
				GJH.JE_CATEGORY,
				GJC.USER_JE_CATEGORY_NAME JE_GATEGORY_NAME,
				gjb.name GL_batch_name,
				GJH.NAME JOURNAL_NAME,
				GJl.DESCRIPTION JOURNAL_LINE_DESC,
				gjh.je_header_id,				
				GJL.JE_LINE_NUM,
				gjl.period_name,
				NVL(gjh.currency_code,GJL.currency_code) currency_code,
				DECODE (gjb.status,  'P', 'Posted',  'U', 'Unposted',  gjb.status) BATCH_STATUS,
				DECODE (gjh.status,  'P', 'Posted',  'U', 'Unposted',  gjh.status) JOURNAL_STATUS,
				DECODE (gjl.status,  'P', 'Posted',  'U', 'Unposted',  gjl.status) JE_LINE_STATUS,	
				to_char(gjh.default_effective_date,'MM/DD/YYYY HH24:MI:SS') JOURNAL_DATE,
				to_char(gjh.posted_date,'MM/DD/YYYY HH24:MI:SS')  Posted_Date,
				case when (xdl.ae_line_num IS NULL )
			THEN NVL(xal.accounted_dr,GJL.accounted_dr) 
			 ELSE xdl.unrounded_accounted_dr
			END ACCOUNTED_DR,
					case when (xdl.ae_line_num IS NULL )
				   THEN NVL(xal.accounted_cr,GJL.accounted_cr) 
			 ELSE xdl.unrounded_accounted_cr
			END ACCOUNTED_CR,
					case when (xdl.ae_line_num IS NULL )
				   THEN NVL(xal.entered_dr,GJL.entered_dr) 
			 ELSE xdl.unrounded_entered_dr
			END ENTERED_DR,
					case when (xdl.ae_line_num IS NULL )
				   THEN NVL(xal.entered_cr,GJL.entered_cr) 
			 ELSE xdl.unrounded_entered_cr
			END ENTERED_CR,
				gcc.segment1 GL_FUND,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,1, gcc.segment1) GL_FUND_DESC,
				GCC.SEGMENT2 GL_COST_CENTER,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,2, gcc.segment2) GL_COST_CENTER_DESC,
				GCC.SEGMENT3 GL_COST_TYPE,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,3, gcc.segment3) GL_COST_TYPE_DESC,
				GCC.SEGMENT4 GL_PROJECT,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,4, gcc.segment4) GL_PROJECT_DESC,
				GCC.SEGMENT5 GL_ACTIVITY_TYPE,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,5, gcc.segment5) GL_ACTIVITY_TYPE_DESC,
				GCC.SEGMENT6 GL_FERC,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,6, gcc.segment6) GL_FERC_DESC,
				GCC.SEGMENT7 GL_BUDGET_CODE,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,7, gcc.segment7) GL_BUDGET_CODE_DESC,
				GCC.SEGMENT8 GL_INTERCOMPANY,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,8, gcc.segment8) GL_INTERCOMPANY_DESC,
				GCC.SEGMENT9 GL_FUTURE1,
				GCC.SEGMENT10 GL_FUTURE2,				
				GJH.reversed_je_header_id,
				xal.application_id,
				xah.ae_header_id,
				xal.ae_line_num,				
				xal.ACCOUNTING_CLASS_CODE,
				XDL.TEMP_LINE_NUM XDL_TEMP_LINE_NUM, 
				XDL.SOURCE_DISTRIBUTION_TYPE XDL_SOURCE_DIST_TYPE,
				XDL.SOURCE_DISTRIBUTION_ID_NUM_1 XDL_SOURCE_DIST_ID_NUM_1,
				XDL.SOURCE_DISTRIBUTION_ID_NUM_2 XDL_SOURCE_DIST_ID_NUM_2,
				XDL.SOURCE_DISTRIBUTION_ID_CHAR_1 XDL_SOURCE_DIST_ID_CHAR_1,
				XDL.ref_ae_header_id XDL_REF_AE_HEADER_ID,
				XE.event_id XLA_EVENT_ID,
				XE.event_type_code XLA_EVENT_TYPE_CODE,
				xte.entity_ID XTE_ENTITY_ID,
				xte.entity_code XTE_ENTITY_CODE,
				XTE.SOURCE_ID_INT_1 XTE_SOURCE_ID_INT_1,
				XTE.SOURCE_ID_INT_2 XTE_SOURCE_ID_INT_2,
				XTE.SOURCE_ID_INT_3 XTE_SOURCE_ID_INT_3,
				XTE.source_id_char_1 XTE_SOURCE_ID_CHAR_1,
				XTE.source_id_char_2 XTE_SOURCE_ID_CHAR_2, 
				XTE.transaction_number XTE_TRANSACTION_NUMBER,
				hp.party_name AR_CUSTOMER_NAME,    
				HCA.ACCOUNT_NUMBER AR_CUSTOMER_ACCOUNT,
				ARA.adjustment_number AR_TRX_NUMBER,
				to_char(rcta.trx_date,'MM/DD/YYYY') AR_TRX_DATE,
				NULL AR_CASH_RCPT_NUM,
				NULL AR_CASH_RCPT_DATE,
				NULL SUPPLIER_NAME,
				NULL SUPPLIER_NUMBER,
				NULL PO_NUMBER,
				NULL PO_LINE_NUM,
				NULL PO_DIST_LINE_NUM,
				NULL INVOICE_NUM,
				NULL VOUCHER_NUM,
				NULL AP_INVOICE_SOURCE,
				ARA.org_id ORG_ID,
				HOU.NAME BU,
				NULL INVOICE_DATE,
				NULL INVOICE_LINE_NUM,
				NULL INVOICE_DIST_LINE_NUM,
				NULL PAYMENT_NUM,
				NULL RECEIPT_NUMBER,
				NULL TRANSACTION_ID,	
				NULL ITEM_NUMBER,
				NULL ITEM_DESCRIPTION,	
				NULL TRANSACTION_QUANTITY,
				NULL TRANSACTION_UOM,
				NULL project_number,
				NULL project_name,
				NULL task_number,
				NULL task_name,
				NULL expenditure_type,
				NULL EXPENDITURE_TYPE_DESC,
				NULL EXPENDITURE_ORG_NAME,
				NULL CDL_LINE_NUM,
				NULL expenditure_comment,
				NULL PJC_TRANSACTION_SOURCE,
				NULL PJC_DOCUMENT_TYPE,
				NULL PJC_DOCUMENT_ENTRY, 
				NULL PJC_BATCH_NAME,
				NULL employee_number, 
				NULL employee_name,
				NULL OMS_Sales_Order,
				NULL OMS_Customer_PO,
				NULL source_code
FROM 	gl_je_lines gjl,
		gl_je_headers gjh,
		gl_je_batches gjb,    
		gl_import_references gir,
		xla_ae_lines xal,
		xla_ae_headers xah,
		xla_distribution_links xdl,
		xla_events xe,
		xla_transaction_entities xte,
		ar_adjustments_all ARA
		,hr_operating_units HOU
		,RA_CUSTOMER_TRX_ALL RCTA
		,HZ_CUST_ACCOUNTS HCA
		,hz_parties hp
		,GL_CODE_COMBINATIONS GCC
		,gl_je_sources GJS
		,gl_je_categories GJC
    ,gl_ledgers gl
WHERE 1=1
		and gjh.ledger_id = gl.ledger_id
		and gjb.je_batch_id  = gjh.je_batch_id
		and gjl.je_header_id = gjh.je_header_id
		and gjh.je_source    = gjs.je_source_name
		and gjh.je_category  = gjc.je_category_name
		and gjl.je_header_id = gir.je_header_id
		and gjl.je_line_num  = gir.je_line_num
		and gir.gl_sl_link_table = xal.gl_sl_link_table
		and gir.gl_sl_link_id    = xal.gl_sl_link_id
		and xal.application_id = xah.application_id
		and xal.ae_header_id   = xah.ae_header_id
		and xah.application_id = xe.application_id
		and xah.ae_header_id = xdl.ae_header_id(+)
		and xal.ae_line_num = xdl.ae_line_num(+)
		and xah.event_id       = xe.event_id 
		and xe.application_id = xte.application_id
		and xe.entity_id      = xte.entity_id
		and xte.application_id    = 222
		and xte.entity_code       = 'ADJUSTMENTS'
		and xte.source_id_int_1   = ARA.adjustment_id(+)
		AND ARA.org_id = HOU.ORGANIZATION_ID(+)
		AND ARA.CUSTOMER_TRX_ID   = rcta.customer_trx_id(+)
		AND RCTA.BILL_TO_CUSTOMER_ID = HCA.CUST_ACCOUNT_ID(+)
		AND HCA.PARTY_ID = HP.PARTY_ID(+)
		and gjl.code_combination_id = gcc.code_combination_id  
		and gjh.actual_flag = 'A'
		AND (GJH.STATUS IN (:P_POSTING_STATUS) OR COALESCE(:P_POSTING_STATUS,null) IS NULL)
		AND	(gjh.PERIOD_NAME IN (:P_PERIOD_NAME) OR COALESCE(:P_PERIOD_NAME,null) IS NULL)
		AND GL.NAME  = :P_LEDGER_NAME
		--Allow Multiselect on the following parameters
		AND	(GCC.SEGMENT1 IN (:P_FUND) OR COALESCE(:P_FUND,null) IS NULL)
		AND	(GCC.SEGMENT2 IN (:P_COST_CENTER) OR COALESCE(:P_COST_CENTER,null) IS NULL)
		AND	(GCC.SEGMENT3 IN (:P_COST_TYPE) OR COALESCE(:P_COST_TYPE,null) IS NULL)
		AND	(GCC.SEGMENT4 IN (:P_PROJECT) OR COALESCE(:P_PROJECT,null) IS NULL)
		AND	(GCC.SEGMENT5 IN (:P_ACTIVITY_TYPE) OR COALESCE(:P_ACTIVITY_TYPE,null) IS NULL)
		AND	(GCC.SEGMENT6 IN (:P_FERC) OR COALESCE(:P_FERC,null) IS NULL)
		AND	(GCC.SEGMENT7 IN (:P_BUDGET_CODE) OR COALESCE(:P_BUDGET_CODE,null) IS NULL)
		AND	(GCC.SEGMENT8 IN (:P_INTERCO) OR COALESCE(:P_INTERCO,null) IS NULL)		
		AND	(GJS.user_je_source_name IN (:P_JE_SOURCE_NAME) OR COALESCE(:P_JE_SOURCE_NAME,null) IS NULL)
		AND	(GJC.USER_JE_CATEGORY_NAME IN (:P_JE_CATEGORY_NAME) OR COALESCE(:P_JE_CATEGORY_NAME,null) IS NULL)
UNION
-- Receivables Receipts
SELECT 			GL.LEDGER_ID,
				GL.NAME LEDGER_NAME,
				GJH.JE_SOURCE,
				GJS.user_je_source_name JE_SOURCE_NAME,
				GJH.JE_CATEGORY,
				GJC.USER_JE_CATEGORY_NAME JE_GATEGORY_NAME,
				gjb.name GL_batch_name,
				GJH.NAME JOURNAL_NAME,
				GJl.DESCRIPTION JOURNAL_LINE_DESC,
				gjh.je_header_id,				
				GJL.JE_LINE_NUM,
				gjl.period_name,
				NVL(gjh.currency_code,GJL.currency_code) currency_code,
				DECODE (gjb.status,  'P', 'Posted',  'U', 'Unposted',  gjb.status) BATCH_STATUS,
				DECODE (gjh.status,  'P', 'Posted',  'U', 'Unposted',  gjh.status) JOURNAL_STATUS,
				DECODE (gjl.status,  'P', 'Posted',  'U', 'Unposted',  gjl.status) JE_LINE_STATUS,	
				to_char(gjh.default_effective_date,'MM/DD/YYYY HH24:MI:SS') JOURNAL_DATE,
				to_char(gjh.posted_date,'MM/DD/YYYY HH24:MI:SS')  Posted_Date,
				NVL(xal.accounted_dr,GJL.accounted_dr) ACCOUNTED_DR,
				NVL(xal.accounted_cr,GJL.accounted_cr) ACCOUNTED_CR,
				NVL(xal.entered_dr,GJL.entered_dr) 		ENTERED_DR,
				NVL(xal.entered_cr,GJL.entered_cr) 		 ENTERED_CR,
				gcc.segment1 GL_FUND,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,1, gcc.segment1) GL_FUND_DESC,
				GCC.SEGMENT2 GL_COST_CENTER,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,2, gcc.segment2) GL_COST_CENTER_DESC,
				GCC.SEGMENT3 GL_COST_TYPE,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,3, gcc.segment3) GL_COST_TYPE_DESC,
				GCC.SEGMENT4 GL_PROJECT,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,4, gcc.segment4) GL_PROJECT_DESC,
				GCC.SEGMENT5 GL_ACTIVITY_TYPE,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,5, gcc.segment5) GL_ACTIVITY_TYPE_DESC,
				GCC.SEGMENT6 GL_FERC,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,6, gcc.segment6) GL_FERC_DESC,
				GCC.SEGMENT7 GL_BUDGET_CODE,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,7, gcc.segment7) GL_BUDGET_CODE_DESC,
				GCC.SEGMENT8 GL_INTERCOMPANY,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,8, gcc.segment8) GL_INTERCOMPANY_DESC,
				GCC.SEGMENT9 GL_FUTURE1,
				GCC.SEGMENT10 GL_FUTURE2,				
				GJH.reversed_je_header_id,
				xal.application_id,
				xah.ae_header_id,
				xal.ae_line_num,				
				xal.ACCOUNTING_CLASS_CODE,
				NULL XDL_TEMP_LINE_NUM, 
				NULL XDL_SOURCE_DIST_TYPE,
				NULL XDL_SOURCE_DIST_ID_NUM_1,
				NULL XDL_SOURCE_DIST_ID_NUM_2,
				NULL XDL_SOURCE_DIST_ID_CHAR_1,
				NULL XDL_REF_AE_HEADER_ID,
				XLAE.event_id XLA_EVENT_ID,
				XLAE.event_type_code XLA_EVENT_TYPE_CODE,
				xte.entity_ID XTE_ENTITY_ID,
				xte.entity_code XTE_ENTITY_CODE,
				XTE.SOURCE_ID_INT_1 XTE_SOURCE_ID_INT_1,
				XTE.SOURCE_ID_INT_2 XTE_SOURCE_ID_INT_2,
				XTE.SOURCE_ID_INT_3 XTE_SOURCE_ID_INT_3,
				XTE.source_id_char_1 XTE_SOURCE_ID_CHAR_1,
				XTE.source_id_char_2 XTE_SOURCE_ID_CHAR_2, 
				XTE.transaction_number XTE_TRANSACTION_NUMBER,
				hp.party_name AR_CUSTOMER_NAME,    
				HCA.ACCOUNT_NUMBER AR_CUSTOMER_ACCOUNT,
				NULL AR_TRX_NUMBER,
				NULL AR_TRX_DATE,
				ACR.receipt_number AR_CASH_RCPT_NUM,
				to_char(ACR.receipt_date,'MM/DD/YYYY') AR_CASH_RCPT_DATE,
				NULL SUPPLIER_NAME,
				NULL SUPPLIER_NUMBER,
				NULL PO_NUMBER,
				NULL PO_LINE_NUM,
				NULL PO_DIST_LINE_NUM,
				NULL INVOICE_NUM,
				NULL VOUCHER_NUM,
				NULL AP_INVOICE_SOURCE,
				acr.org_id ORG_ID,
				hou.name BU, --check
				NULL INVOICE_DATE,
				NULL INVOICE_LINE_NUM,
				NULL INVOICE_DIST_LINE_NUM,
				NULL PAYMENT_NUM,
				NULL RECEIPT_NUMBER,
				NULL TRANSACTION_ID,	
				NULL ITEM_NUMBER,
				NULL ITEM_DESCRIPTION,	
				NULL TRANSACTION_QUANTITY,
				NULL TRANSACTION_UOM,
				NULL project_number,
				NULL project_name,
				NULL task_number,
				NULL task_name,
				NULL expenditure_type,
				NULL EXPENDITURE_TYPE_DESC,
				NULL EXPENDITURE_ORG_NAME,
				NULL CDL_LINE_NUM,
				NULL expenditure_comment,
				NULL PJC_TRANSACTION_SOURCE,
				NULL PJC_DOCUMENT_TYPE,
				NULL PJC_DOCUMENT_ENTRY, 
				NULL PJC_BATCH_NAME,
				NULL employee_number, 
				NULL employee_name,
				NULL OMS_Sales_Order,
				NULL OMS_Customer_PO,
				NULL source_code	
        FROM   xla_transaction_entities xte, 
               xla_ae_headers xah, 
               xla_ae_lines xal, 
           --  xla_distribution_links xdl, 
               gl_import_references gir, 
               gl_je_lines gjl, 
               gl_je_headers gjh, 
               gl_je_batches gjb, 
               gl_code_combinations gcc, 
			   hr_operating_units hou,
               gl_ledgers gl, 
               xla_events xlae, 
               ar_cash_receipts_all acr,
             --  ra_customer_trx_all          rct,
            --  ra_cust_trx_line_gl_dist_all rctd   
               hz_cust_accounts hca,
			   gl_je_sources GJS,
			   gl_je_categories GJC,
			   hz_parties hp
            -- poz_suppliers_v poz			   
        WHERE  1 = 1 
            AND xte.entity_code = 'RECEIPTS'
            AND xte.ledger_id = gl.ledger_id 
            AND xah.ae_header_id = xal.ae_header_id 
            AND xal.application_id = xah.application_id 
            AND xal.gl_sl_link_id = gir.gl_sl_link_id 
            AND xal.gl_sl_link_table = gir.gl_sl_link_table 
            --AND xah.ae_header_id = xdl.ae_header_id 
            --AND xal.ae_line_num = xdl.ae_line_num 
            AND gir.je_header_id = gjl.je_header_id 
			and gjh.je_source    = gjs.je_source_name
			and gjh.je_category  = gjc.je_category_name
            AND gir.je_line_num = gjl.je_line_num 
            AND gjl.je_header_id = gjh.je_header_id 
            AND gjb.je_source = 'Receivables' 
            AND gjb.je_batch_id = gjh.je_batch_id 
            AND gjl.code_combination_id = gcc.code_combination_id 
            AND gjh.ledger_id = gl.ledger_id 
            AND xah.application_id = xlae.application_id 
            AND xah.event_id = xlae.event_id 
            AND xlae.application_id = xte.application_id 
            AND xlae.entity_id = xte.entity_id 
            AND xte.source_id_int_1 =  acr.cash_receipt_id
		    AND hca.CUST_ACCOUNT_ID(+) = acr.PAY_FROM_CUSTOMER
			AND HCA.PARTY_ID = HP.PARTY_ID(+)
			and acr.org_id = hou.organization_id(+) 
			and gjh.actual_flag = 'A'
		AND (GJH.STATUS IN (:P_POSTING_STATUS) OR COALESCE(:P_POSTING_STATUS,null) IS NULL)
		AND	(gjh.PERIOD_NAME IN (:P_PERIOD_NAME) OR COALESCE(:P_PERIOD_NAME,null) IS NULL)
		AND GL.NAME  = :P_LEDGER_NAME
		--Allow Multiselect on the following parameters
		AND	(GCC.SEGMENT1 IN (:P_FUND) OR COALESCE(:P_FUND,null) IS NULL)
		AND	(GCC.SEGMENT2 IN (:P_COST_CENTER) OR COALESCE(:P_COST_CENTER,null) IS NULL)
		AND	(GCC.SEGMENT3 IN (:P_COST_TYPE) OR COALESCE(:P_COST_TYPE,null) IS NULL)
		AND	(GCC.SEGMENT4 IN (:P_PROJECT) OR COALESCE(:P_PROJECT,null) IS NULL)
		AND	(GCC.SEGMENT5 IN (:P_ACTIVITY_TYPE) OR COALESCE(:P_ACTIVITY_TYPE,null) IS NULL)
		AND	(GCC.SEGMENT6 IN (:P_FERC) OR COALESCE(:P_FERC,null) IS NULL)
		AND	(GCC.SEGMENT7 IN (:P_BUDGET_CODE) OR COALESCE(:P_BUDGET_CODE,null) IS NULL)
		AND	(GCC.SEGMENT8 IN (:P_INTERCO) OR COALESCE(:P_INTERCO,null) IS NULL)		
		AND	(GJS.user_je_source_name IN (:P_JE_SOURCE_NAME) OR COALESCE(:P_JE_SOURCE_NAME,null) IS NULL)
		AND	(GJC.USER_JE_CATEGORY_NAME IN (:P_JE_CATEGORY_NAME) OR COALESCE(:P_JE_CATEGORY_NAME,null) IS NULL)																	 
UNION
--Payables query		
SELECT 			GL.LEDGER_ID,
				GL.NAME LEDGER_NAME,
				GJH.JE_SOURCE,
				GJS.user_je_source_name JE_SOURCE_NAME,
				GJH.JE_CATEGORY,
				GJC.USER_JE_CATEGORY_NAME JE_GATEGORY_NAME,
				gjb.name GL_batch_name,
				GJH.NAME JOURNAL_NAME,
				GJl.DESCRIPTION JOURNAL_LINE_DESC,
				gjh.je_header_id,				
				GJL.JE_LINE_NUM,
				gjl.period_name,
				NVL(gjh.currency_code,GJL.currency_code) currency_code,
				DECODE (gjb.status,  'P', 'Posted',  'U', 'Unposted',  gjb.status) BATCH_STATUS,
				DECODE (gjh.status,  'P', 'Posted',  'U', 'Unposted',  gjh.status) JOURNAL_STATUS,
				DECODE (gjl.status,  'P', 'Posted',  'U', 'Unposted',  gjl.status) JE_LINE_STATUS,	
				to_char(gjh.default_effective_date,'MM/DD/YYYY HH24:MI:SS') JOURNAL_DATE,
				to_char(gjh.posted_date,'MM/DD/YYYY HH24:MI:SS')  Posted_Date,
				case when (xdl.ae_line_num IS NULL )
			THEN NVL(xal.accounted_dr,GJL.accounted_dr) 
			 ELSE xdl.unrounded_accounted_dr
			END ACCOUNTED_DR,
					case when (xdl.ae_line_num IS NULL )
				   THEN NVL(xal.accounted_cr,GJL.accounted_cr) 
			 ELSE xdl.unrounded_accounted_cr
			END ACCOUNTED_CR,
					case when (xdl.ae_line_num IS NULL )
				   THEN NVL(xal.entered_dr,GJL.entered_dr) 
			 ELSE xdl.unrounded_entered_dr
			END ENTERED_DR,
					case when (xdl.ae_line_num IS NULL )
				   THEN NVL(xal.entered_cr,GJL.entered_cr) 
			 ELSE xdl.unrounded_entered_cr
			END ENTERED_CR,
				gcc.segment1 GL_FUND,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,1, gcc.segment1) GL_FUND_DESC,
				GCC.SEGMENT2 GL_COST_CENTER,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,2, gcc.segment2) GL_COST_CENTER_DESC,
				GCC.SEGMENT3 GL_COST_TYPE,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,3, gcc.segment3) GL_COST_TYPE_DESC,
				GCC.SEGMENT4 GL_PROJECT,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,4, gcc.segment4) GL_PROJECT_DESC,
				GCC.SEGMENT5 GL_ACTIVITY_TYPE,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,5, gcc.segment5) GL_ACTIVITY_TYPE_DESC,
				GCC.SEGMENT6 GL_FERC,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,6, gcc.segment6) GL_FERC_DESC,
				GCC.SEGMENT7 GL_BUDGET_CODE,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,7, gcc.segment7) GL_BUDGET_CODE_DESC,
				GCC.SEGMENT8 GL_INTERCOMPANY,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,8, gcc.segment8) GL_INTERCOMPANY_DESC,
				GCC.SEGMENT9 GL_FUTURE1,
				GCC.SEGMENT10 GL_FUTURE2,				
				GJH.reversed_je_header_id,
				xal.application_id,
				xah.ae_header_id,
				xal.ae_line_num,				
				xal.ACCOUNTING_CLASS_CODE,
				XDL.TEMP_LINE_NUM XDL_TEMP_LINE_NUM, 
				XDL.SOURCE_DISTRIBUTION_TYPE XDL_SOURCE_DIST_TYPE,
				XDL.SOURCE_DISTRIBUTION_ID_NUM_1 XDL_SOURCE_DIST_ID_NUM_1,
				XDL.SOURCE_DISTRIBUTION_ID_NUM_2 XDL_SOURCE_DIST_ID_NUM_2,
				XDL.SOURCE_DISTRIBUTION_ID_CHAR_1 XDL_SOURCE_DIST_ID_CHAR_1,
				XDL.ref_ae_header_id XDL_REF_AE_HEADER_ID,
				XE.event_id XLA_EVENT_ID,
				XE.event_type_code XLA_EVENT_TYPE_CODE,
				xte.entity_ID XTE_ENTITY_ID,
				xte.entity_code XTE_ENTITY_CODE,
				XTE.SOURCE_ID_INT_1 XTE_SOURCE_ID_INT_1,
				XTE.SOURCE_ID_INT_2 XTE_SOURCE_ID_INT_2,
				XTE.SOURCE_ID_INT_3 XTE_SOURCE_ID_INT_3,
				XTE.source_id_char_1 XTE_SOURCE_ID_CHAR_1,
				XTE.source_id_char_2 XTE_SOURCE_ID_CHAR_2, 
				XTE.transaction_number XTE_TRANSACTION_NUMBER,
				NULL AR_CUSTOMER_NAME,    
				NULL AR_CUSTOMER_ACCOUNT,
				NULL AR_TRX_NUMBER,
				NULL AR_TRX_DATE,
				NULL AR_CASH_RCPT_NUM,
				NULL AR_CASH_RCPT_DATE,
				coalesce(HP.PARTY_NAME,HP1.PARTY_NAME) SUPPLIER_NAME,
				coalesce(PS.SEGMENT1,PAPF.PERSON_NUMBER) SUPPLIER_NUMBER,
				PHA.segment1 PO_NUMBER,
				NULL PO_LINE_NUM,
				NULL PO_DIST_LINE_NUM,
				AIA.invoice_num INVOICE_NUM,
				NVL(AIA.DOC_SEQUENCE_VALUE,AIA.voucher_num) VOUCHER_NUM,
				AIA.source AP_INVOICE_SOURCE,
				AIA.org_id ORG_ID,
				HOU.NAME BU,
				to_char(AIA.invoice_date,'MM/DD/YYYY') INVOICE_DATE,
				AIDA.invoice_line_number INVOICE_LINE_NUM,
				AIDA.distribution_line_number INVOICE_DIST_LINE_NUM,
				NULL PAYMENT_NUM,
				NULL RECEIPT_NUMBER,
				NULL TRANSACTION_ID,	
				NULL ITEM_NUMBER,
				AIDA.Description ITEM_DESCRIPTION,	
				AIDA.QUANTITY_INVOICED TRANSACTION_QUANTITY,
				NULL TRANSACTION_UOM,
				PPV.SEGMENT1 project_number,
                PPV.NAME PROJECT_NAME,
                TO_CHAR(PPE.ELEMENT_NUMBER) AS TASK_NUMBER,
				PPE.NAME TASK_NAME,
				PET.EXPENDITURE_TYPE_NAME AS EXPENDITURE_TYPE,
				NULL EXPENDITURE_TYPE_DESC,
		        hou1.name EXPENDITURE_ORG_NAME,
				NULL CDL_LINE_NUM,
				NULL expenditure_comment,
				NULL PJC_TRANSACTION_SOURCE,
				NULL PJC_DOCUMENT_TYPE,
				NULL PJC_DOCUMENT_ENTRY, 
				NULL PJC_BATCH_NAME,
				NULL employee_number, 
				NULL employee_name,
				NULL OMS_Sales_Order,
				NULL OMS_Customer_PO,
				NULL source_code
FROM 			 gl_je_lines gjl
				,gl_je_headers gjh
				,gl_je_batches gjb   
				,gl_import_references gir
				,xla_ae_lines xal
				,xla_ae_headers xah
				,xla_distribution_links xdl
				,xla_events xe
				,xla_transaction_entities xte
				,ap_invoices_all aia
				,AP_INVOICE_LINES_ALL AIL
				,PO_HEADERS_ALL PHA
				,ap_invoice_distributions_all AIDA
				,PJF_PROJECTS_ALL_VL PPV
                ,PJF_PROJ_ELEMENTS_VL PPE
                ,PJF_EXP_TYPES_TL PET
				,hr_operating_units HOU
				,hr_operating_units HOU1
				,poz_suppliers ps
				,hz_parties hp
                ,HZ_PARTIES HP1
				,PER_ALL_PEOPLE_F PAPF 
				,hz_orig_sys_references hosr
				,GL_CODE_COMBINATIONS GCC
				,gl_je_sources GJS
				,gl_je_categories GJC
				,gl_ledgers gl
WHERE 1=1
		and gjh.ledger_id    = gl.ledger_id
		and gjb.je_batch_id  = gjh.je_batch_id
		and gjh.je_header_id = gjl.je_header_id 
		and gjh.je_source    = gjs.je_source_name
		and gjh.je_category  = gjc.je_category_name
		and gjl.je_header_id = gir.je_header_id
		and gjl.je_line_num  = gir.je_line_num
		and gir.gl_sl_link_table = xal.gl_sl_link_table
		and gir.gl_sl_link_id    = xal.gl_sl_link_id
		and xal.application_id = xah.application_id
		and xal.ae_header_id   = xah.ae_header_id
		and xah.application_id = xe.application_id
		and xah.event_id       = xe.event_id 
		and xah.ae_header_id = xdl.ae_header_id(+)
		and xal.ae_line_num = xdl.ae_line_num(+)
		and xe.application_id = xte.application_id
		and xe.entity_id      = xte.entity_id
		and xte.entity_code       IN ('AP_INVOICES')
		and xte.source_id_int_1   = aia.invoice_id(+)
		AND AIA.po_header_id    = PHA.po_header_id(+)
		AND AIA.org_id = HOU.ORGANIZATION_ID(+)
		and xdl.source_distribution_id_num_1 = AIDA.invoice_distribution_id(+)
		and AIDA.INVOICE_ID = AIA.INVOICE_ID(+)                                   -- new joins 
        AND AIDA.INVOICE_ID = AIL.INVOICE_ID(+)
        AND AIDA.INVOICE_LINE_NUMBER = AIL.LINE_NUMBER(+)
        AND AIDA.PJC_EXPENDITURE_TYPE_ID = PET.EXPENDITURE_TYPE_ID(+)
        AND AIDA.PJC_PROJECT_ID = PPV.PROJECT_ID(+)
        AND AIDA.PJC_TASK_ID = PPE.PROJ_ELEMENT_ID(+)
		AND AIDA.PJC_ORGANIZATION_ID = hou1.organization_id(+)
		and aia.vendor_id = ps.vendor_id(+)
		and ps.party_id = hp.party_id(+)
		AND AIA.PARTY_ID = HP1.PARTY_ID(+)				
		and HP1.PARTY_ID=HOSR.OWNER_TABLE_ID(+)
		AND HOSR.ORIG_SYSTEM_REFERENCE = PAPF.PERSON_ID(+)
		and HOSR.ORIG_SYSTEM (+)= 'FUSION_HCM'
		and HOSR.OWNER_TABLE_NAME (+)='HZ_PARTIES'
		and gjl.code_combination_id = gcc.code_combination_id 
		and gjh.actual_flag = 'A'
        --and PPV.segment1 is not null
        --AND ppb.segment1 = 'SP12001'	
		AND (GJH.STATUS IN (:P_POSTING_STATUS) OR COALESCE(:P_POSTING_STATUS,null) IS NULL)
		AND	(gjh.PERIOD_NAME IN (:P_PERIOD_NAME) OR COALESCE(:P_PERIOD_NAME,null) IS NULL)
		AND GL.NAME  = :P_LEDGER_NAME
		--Allow Multiselect on the following parameters
		AND	(GCC.SEGMENT1 IN (:P_FUND) OR COALESCE(:P_FUND,null) IS NULL)
		AND	(GCC.SEGMENT2 IN (:P_COST_CENTER) OR COALESCE(:P_COST_CENTER,null) IS NULL)
		AND	(GCC.SEGMENT3 IN (:P_COST_TYPE) OR COALESCE(:P_COST_TYPE,null) IS NULL)
		AND	(GCC.SEGMENT4 IN (:P_PROJECT) OR COALESCE(:P_PROJECT,null) IS NULL)
		AND	(GCC.SEGMENT5 IN (:P_ACTIVITY_TYPE) OR COALESCE(:P_ACTIVITY_TYPE,null) IS NULL)
		AND	(GCC.SEGMENT6 IN (:P_FERC) OR COALESCE(:P_FERC,null) IS NULL)
		AND	(GCC.SEGMENT7 IN (:P_BUDGET_CODE) OR COALESCE(:P_BUDGET_CODE,null) IS NULL)
		AND	(GCC.SEGMENT8 IN (:P_INTERCO) OR COALESCE(:P_INTERCO,null) IS NULL)		
		AND	(GJS.user_je_source_name IN (:P_JE_SOURCE_NAME) OR COALESCE(:P_JE_SOURCE_NAME,null) IS NULL)
		AND	(GJC.USER_JE_CATEGORY_NAME IN (:P_JE_CATEGORY_NAME) OR COALESCE(:P_JE_CATEGORY_NAME,null) IS NULL)			
UNION
--AP Payments
SELECT 			GL.LEDGER_ID,
				GL.NAME LEDGER_NAME,
				GJH.JE_SOURCE,
				GJS.user_je_source_name JE_SOURCE_NAME,
				GJH.JE_CATEGORY,
				GJC.USER_JE_CATEGORY_NAME JE_GATEGORY_NAME,
				gjb.name GL_batch_name,
				GJH.NAME JOURNAL_NAME,
				GJl.DESCRIPTION JOURNAL_LINE_DESC,
				gjh.je_header_id,				
				GJL.JE_LINE_NUM,
				gjl.period_name,
				NVL(gjh.currency_code,GJL.currency_code) currency_code,
				DECODE (gjb.status,  'P', 'Posted',  'U', 'Unposted',  gjb.status) BATCH_STATUS,
				DECODE (gjh.status,  'P', 'Posted',  'U', 'Unposted',  gjh.status) JOURNAL_STATUS,
				DECODE (gjl.status,  'P', 'Posted',  'U', 'Unposted',  gjl.status) JE_LINE_STATUS,	
				to_char(gjh.default_effective_date,'MM/DD/YYYY HH24:MI:SS') JOURNAL_DATE,
				to_char(gjh.posted_date,'MM/DD/YYYY HH24:MI:SS')  Posted_Date,
				case when (xdl.ae_line_num IS NULL )
			THEN NVL(xal.accounted_dr,GJL.accounted_dr) 
			 ELSE xdl.unrounded_accounted_dr
			END ACCOUNTED_DR,
					case when (xdl.ae_line_num IS NULL )
				   THEN NVL(xal.accounted_cr,GJL.accounted_cr) 
			 ELSE xdl.unrounded_accounted_cr
			END ACCOUNTED_CR,
					case when (xdl.ae_line_num IS NULL )
				   THEN NVL(xal.entered_dr,GJL.entered_dr) 
			 ELSE xdl.unrounded_entered_dr
			END ENTERED_DR,
					case when (xdl.ae_line_num IS NULL )
				   THEN NVL(xal.entered_cr,GJL.entered_cr) 
			 ELSE xdl.unrounded_entered_cr
			END ENTERED_CR,
				gcc.segment1 GL_FUND,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,1, gcc.segment1) GL_FUND_DESC,
				GCC.SEGMENT2 GL_COST_CENTER,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,2, gcc.segment2) GL_COST_CENTER_DESC,
				GCC.SEGMENT3 GL_COST_TYPE,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,3, gcc.segment3) GL_COST_TYPE_DESC,
				GCC.SEGMENT4 GL_PROJECT,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,4, gcc.segment4) GL_PROJECT_DESC,
				GCC.SEGMENT5 GL_ACTIVITY_TYPE,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,5, gcc.segment5) GL_ACTIVITY_TYPE_DESC,
				GCC.SEGMENT6 GL_FERC,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,6, gcc.segment6) GL_FERC_DESC,
				GCC.SEGMENT7 GL_BUDGET_CODE,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,7, gcc.segment7) GL_BUDGET_CODE_DESC,
				GCC.SEGMENT8 GL_INTERCOMPANY,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,8, gcc.segment8) GL_INTERCOMPANY_DESC,
				GCC.SEGMENT9 GL_FUTURE1,
				GCC.SEGMENT10 GL_FUTURE2,				
				GJH.reversed_je_header_id,
				xal.application_id,
				xah.ae_header_id,
				xal.ae_line_num,				
				xal.ACCOUNTING_CLASS_CODE,
				XDL.TEMP_LINE_NUM XDL_TEMP_LINE_NUM, 
				XDL.SOURCE_DISTRIBUTION_TYPE XDL_SOURCE_DIST_TYPE,
				XDL.SOURCE_DISTRIBUTION_ID_NUM_1 XDL_SOURCE_DIST_ID_NUM_1,
				XDL.SOURCE_DISTRIBUTION_ID_NUM_2 XDL_SOURCE_DIST_ID_NUM_2,
				XDL.SOURCE_DISTRIBUTION_ID_CHAR_1 XDL_SOURCE_DIST_ID_CHAR_1,
				XDL.ref_ae_header_id XDL_REF_AE_HEADER_ID,
				XE.event_id XLA_EVENT_ID,
				XE.event_type_code XLA_EVENT_TYPE_CODE,
				xte.entity_ID XTE_ENTITY_ID,
				xte.entity_code XTE_ENTITY_CODE,
				XTE.SOURCE_ID_INT_1 XTE_SOURCE_ID_INT_1,
				XTE.SOURCE_ID_INT_2 XTE_SOURCE_ID_INT_2,
				XTE.SOURCE_ID_INT_3 XTE_SOURCE_ID_INT_3,
				XTE.source_id_char_1 XTE_SOURCE_ID_CHAR_1,
				XTE.source_id_char_2 XTE_SOURCE_ID_CHAR_2, 
				XTE.transaction_number XTE_TRANSACTION_NUMBER,
				NULL AR_CUSTOMER_NAME,    
				NULL AR_CUSTOMER_ACCOUNT,
				NULL AR_TRX_NUMBER,
				NULL AR_TRX_DATE,
				NULL AR_CASH_RCPT_NUM,
				NULL AR_CASH_RCPT_DATE,
				COALESCE(aca.vendor_name,HP.PARTY_NAME) SUPPLIER_NAME,
				PS.SEGMENT1 SUPPLIER_NUMBER,
				NULL PO_NUMBER,
				NULL PO_LINE_NUM,
				NULL PO_DIST_LINE_NUM,
				AIA.invoice_num INVOICE_NUM,
				NVL(AIA.DOC_SEQUENCE_VALUE,AIA.voucher_num) VOUCHER_NUM,
				AIA.source AP_INVOICE_SOURCE,
				ACA.org_id ORG_ID,
				HOU.NAME BU,
				to_char(AIA.invoice_date,'MM/DD/YYYY') INVOICE_DATE,
				NULL INVOICE_LINE_NUM,
				NULL INVOICE_DIST_LINE_NUM,
				ACA.check_number PAYMENT_NUM,
				NULL RECEIPT_NUMBER,
				NULL TRANSACTION_ID,				
				NULL ITEM_NUMBER,
				NULL ITEM_DESCRIPTION,	
				NULL TRANSACTION_QUANTITY,
				NULL TRANSACTION_UOM,
				NULL project_number,
				NULL project_name,
				NULL task_number,
				NULL task_name,
				NULL expenditure_type,
				NULL EXPENDITURE_TYPE_DESC,
				NULL EXPENDITURE_ORG_NAME,
				NULL CDL_LINE_NUM,
				NULL expenditure_comment,
				NULL PJC_TRANSACTION_SOURCE,
				NULL PJC_DOCUMENT_TYPE,
				NULL PJC_DOCUMENT_ENTRY, 
				NULL PJC_BATCH_NAME,
				NULL employee_number, 
				NULL employee_name,
				NULL OMS_Sales_Order,
				NULL OMS_Customer_PO,
				NULL source_code				
FROM 		gl_je_lines gjl
			,gl_je_headers gjh
			,gl_je_batches gjb   
			,gl_import_references gir
			,xla_ae_lines xal
			,xla_ae_headers xah
			,xla_distribution_links xdl
			,xla_events xe
			,xla_transaction_entities xte			
			,AP_CHECKS_ALL ACA
			,hr_operating_units HOU
			-- ,ap_invoice_payments_all AIPA
			,ap_invoices_all aia
			--,ap_invoices_all aia1
			--,ap_payment_hist_dists APHD
			,poz_suppliers ps
			,hz_parties hp
			,GL_CODE_COMBINATIONS GCC
			,gl_je_sources GJS
			,gl_je_categories GJC
			,gl_ledgers gl
	WHERE 1=1
			and gjh.ledger_id    = gl.ledger_id
			and gjb.je_batch_id  = gjh.je_batch_id
			and gjh.je_header_id = gjl.je_header_id 
			and gjh.je_source    = gjs.je_source_name
			and gjh.je_category  = gjc.je_category_name
			and gjl.je_header_id = gir.je_header_id
			and gjl.je_line_num  = gir.je_line_num
			and gir.gl_sl_link_table = xal.gl_sl_link_table
			and gir.gl_sl_link_id    = xal.gl_sl_link_id
			and xal.application_id = xah.application_id
			and xal.ae_header_id   = xah.ae_header_id
			and xah.application_id = xe.application_id
			and xah.event_id       = xe.event_id 
			and xah.ae_header_id = xdl.ae_header_id(+)
			and xal.ae_line_num = xdl.ae_line_num(+)
			and xe.application_id = xte.application_id
			and xe.entity_id      = xte.entity_id
			and xte.entity_code       IN ('AP_PAYMENTS')
			and xte.source_id_int_1   = ACA.CHECK_ID(+)
			AND ACA.org_id = HOU.ORGANIZATION_ID(+)
			--AND ACA.CHECK_ID = AIPA.check_id(+)
			--AND ACA.payment_id = AIPA.invoice_payment_id(+)
			--AND AIPA.invoice_id = AIA1.invoice_id(+)
			and xdl.applied_to_source_id_num_1 = AIA.INVOICE_ID(+)
			and aca.PARTY_id = ps.party_id(+)
			and ACA.party_id = hp.party_id(+)
			and gjl.code_combination_id = gcc.code_combination_id 
			and gjh.actual_flag = 'A'			
			AND (GJH.STATUS IN (:P_POSTING_STATUS) OR COALESCE(:P_POSTING_STATUS,null) IS NULL)
		   AND	(gjh.PERIOD_NAME IN (:P_PERIOD_NAME) OR COALESCE(:P_PERIOD_NAME,null) IS NULL)
			AND GL.NAME  = :P_LEDGER_NAME
			--Allow Multiselect on the following parameters
			AND	(GCC.SEGMENT1 IN (:P_FUND) OR COALESCE(:P_FUND,null) IS NULL)
			AND	(GCC.SEGMENT2 IN (:P_COST_CENTER) OR COALESCE(:P_COST_CENTER,null) IS NULL)
			AND	(GCC.SEGMENT3 IN (:P_COST_TYPE) OR COALESCE(:P_COST_TYPE,null) IS NULL)
			AND	(GCC.SEGMENT4 IN (:P_PROJECT) OR COALESCE(:P_PROJECT,null) IS NULL)
			AND	(GCC.SEGMENT5 IN (:P_ACTIVITY_TYPE) OR COALESCE(:P_ACTIVITY_TYPE,null) IS NULL)
			AND	(GCC.SEGMENT6 IN (:P_FERC) OR COALESCE(:P_FERC,null) IS NULL)
			AND	(GCC.SEGMENT7 IN (:P_BUDGET_CODE) OR COALESCE(:P_BUDGET_CODE,null) IS NULL)
			AND	(GCC.SEGMENT8 IN (:P_INTERCO) OR COALESCE(:P_INTERCO,null) IS NULL)			
			AND	(GJS.user_je_source_name IN (:P_JE_SOURCE_NAME) OR COALESCE(:P_JE_SOURCE_NAME,null) IS NULL)
			AND	(GJC.USER_JE_CATEGORY_NAME IN (:P_JE_CATEGORY_NAME) OR COALESCE(:P_JE_CATEGORY_NAME,null) IS NULL)
UNION 
SELECT 			GL.LEDGER_ID,
				GL.NAME LEDGER_NAME,
				GJH.JE_SOURCE,
				GJS.user_je_source_name JE_SOURCE_NAME,
				GJH.JE_CATEGORY,
				GJC.USER_JE_CATEGORY_NAME JE_GATEGORY_NAME,
				gjb.name GL_batch_name,
				GJH.NAME JOURNAL_NAME,
				GJl.DESCRIPTION JOURNAL_LINE_DESC,
				gjh.je_header_id,				
				GJL.JE_LINE_NUM,
				gjl.period_name,
				NVL(gjh.currency_code,GJL.currency_code) currency_code,
				DECODE (gjb.status,  'P', 'Posted',  'U', 'Unposted',  gjb.status) BATCH_STATUS,
				DECODE (gjh.status,  'P', 'Posted',  'U', 'Unposted',  gjh.status) JOURNAL_STATUS,
				DECODE (gjl.status,  'P', 'Posted',  'U', 'Unposted',  gjl.status) JE_LINE_STATUS,	
				to_char(gjh.default_effective_date,'MM/DD/YYYY HH24:MI:SS') JOURNAL_DATE,
				to_char(gjh.posted_date,'MM/DD/YYYY HH24:MI:SS')  Posted_Date,
				case when (xdl.ae_line_num IS NULL )
			THEN NVL(xal.accounted_dr,GJL.accounted_dr) 
			 ELSE xdl.unrounded_accounted_dr
			END ACCOUNTED_DR,
					case when (xdl.ae_line_num IS NULL )
				   THEN NVL(xal.accounted_cr,GJL.accounted_cr) 
			 ELSE xdl.unrounded_accounted_cr
			END ACCOUNTED_CR,
					case when (xdl.ae_line_num IS NULL )
				   THEN NVL(xal.entered_dr,GJL.entered_dr) 
			 ELSE xdl.unrounded_entered_dr
			END ENTERED_DR,
					case when (xdl.ae_line_num IS NULL )
				   THEN NVL(xal.entered_cr,GJL.entered_cr) 
			 ELSE xdl.unrounded_entered_cr
			END ENTERED_CR,
				gcc.segment1 GL_FUND,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,1, gcc.segment1) GL_FUND_DESC,
				GCC.SEGMENT2 GL_COST_CENTER,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,2, gcc.segment2) GL_COST_CENTER_DESC,
				GCC.SEGMENT3 GL_COST_TYPE,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,3, gcc.segment3) GL_COST_TYPE_DESC,
				GCC.SEGMENT4 GL_PROJECT,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,4, gcc.segment4) GL_PROJECT_DESC,
				GCC.SEGMENT5 GL_ACTIVITY_TYPE,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,5, gcc.segment5) GL_ACTIVITY_TYPE_DESC,
				GCC.SEGMENT6 GL_FERC,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,6, gcc.segment6) GL_FERC_DESC,
				GCC.SEGMENT7 GL_BUDGET_CODE,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,7, gcc.segment7) GL_BUDGET_CODE_DESC,
				GCC.SEGMENT8 GL_INTERCOMPANY,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,8, gcc.segment8) GL_INTERCOMPANY_DESC,
				GCC.SEGMENT9 GL_FUTURE1,
				GCC.SEGMENT10 GL_FUTURE2,				
				GJH.reversed_je_header_id,
				xal.application_id,
				xah.ae_header_id,
				xal.ae_line_num,				
				xal.ACCOUNTING_CLASS_CODE,
				XDL.TEMP_LINE_NUM XDL_TEMP_LINE_NUM, 
				XDL.SOURCE_DISTRIBUTION_TYPE XDL_SOURCE_DIST_TYPE,
				XDL.SOURCE_DISTRIBUTION_ID_NUM_1 XDL_SOURCE_DIST_ID_NUM_1,
				XDL.SOURCE_DISTRIBUTION_ID_NUM_2 XDL_SOURCE_DIST_ID_NUM_2,
				XDL.SOURCE_DISTRIBUTION_ID_CHAR_1 XDL_SOURCE_DIST_ID_CHAR_1,
				XDL.ref_ae_header_id XDL_REF_AE_HEADER_ID,
				XE.event_id XLA_EVENT_ID,
				XE.event_type_code XLA_EVENT_TYPE_CODE,
				xte.entity_ID XTE_ENTITY_ID,
				xte.entity_code XTE_ENTITY_CODE,
				XTE.SOURCE_ID_INT_1 XTE_SOURCE_ID_INT_1,
				XTE.SOURCE_ID_INT_2 XTE_SOURCE_ID_INT_2,
				XTE.SOURCE_ID_INT_3 XTE_SOURCE_ID_INT_3,
				XTE.source_id_char_1 XTE_SOURCE_ID_CHAR_1,
				XTE.source_id_char_2 XTE_SOURCE_ID_CHAR_2, 
				XTE.transaction_number XTE_TRANSACTION_NUMBER,
				NULL AR_CUSTOMER_NAME,    
				NULL AR_CUSTOMER_ACCOUNT,
				NULL AR_TRX_NUMBER,
				NULL AR_TRX_DATE,
				NULL AR_CASH_RCPT_NUM,
				NULL AR_CASH_RCPT_DATE,
				HP.PARTY_NAME SUPPLIER_NAME,
				PS.SEGMENT1 SUPPLIER_NUMBER,
				PHA.segment1 PO_NUMBER,
				NULL PO_LINE_NUM,
				NULL PO_DIST_LINE_NUM,
				NULL INVOICE_NUM,
				NULL VOUCHER_NUM,
				NULL AP_INVOICE_SOURCE,
				NULL ORG_ID,
				NULL BU,
				NULL INVOICE_DATE,
				NULL INVOICE_LINE_NUM,
				NULL INVOICE_DIST_LINE_NUM,
				NULL PAYMENT_NUM,
				NULL RECEIPT_NUMBER,
				NULL TRANSACTION_ID,
				NULL ITEM_NUMBER,
				NULL ITEM_DESCRIPTION,	
				NULL TRANSACTION_QUANTITY,
				NULL TRANSACTION_UOM,
				NULL project_number,
				NULL project_name,
				NULL task_number,
				NULL task_name,
				NULL expenditure_type,
				NULL EXPENDITURE_TYPE_DESC,
				NULL EXPENDITURE_ORG_NAME,
				NULL CDL_LINE_NUM,
				NULL expenditure_comment,
				NULL PJC_TRANSACTION_SOURCE,
				NULL PJC_DOCUMENT_TYPE,
				NULL PJC_DOCUMENT_ENTRY, 
				NULL PJC_BATCH_NAME,
				NULL employee_number, 
				NULL employee_name,
				NULL OMS_Sales_Order,
				NULL OMS_Customer_PO,
				NULL source_code				
FROM 		gl_je_lines gjl
				,gl_je_headers gjh
				,gl_je_batches gjb   
				,gl_import_references gir
				,xla_ae_lines xal
				,xla_ae_headers xah
				,xla_distribution_links xdl
				,xla_events xe
				,xla_transaction_entities xte
				,PO_HEADERS_ALL PHA
				,poz_suppliers ps
				,hz_parties hp
				,GL_CODE_COMBINATIONS GCC
				,gl_je_sources GJS
				,gl_je_categories GJC
				,gl_ledgers gl
	WHERE 1=1
		and gjh.ledger_id = gl.ledger_id
		and gjb.je_batch_id  = gjh.je_batch_id
		and gjh.je_header_id = gjl.je_header_id 
		and gjh.je_source    = gjs.je_source_name
		and gjh.je_category  = gjc.je_category_name
		and gjl.je_header_id = gir.je_header_id
		and gjl.je_line_num  = gir.je_line_num
		and gir.gl_sl_link_table = xal.gl_sl_link_table
		and gir.gl_sl_link_id    = xal.gl_sl_link_id
		and xal.application_id = xah.application_id
		and xal.ae_header_id   = xah.ae_header_id
		and xah.application_id = xe.application_id
		and xah.event_id       = xe.event_id 
		and xah.ae_header_id = xdl.ae_header_id(+)
		and xal.ae_line_num = xdl.ae_line_num(+)
		and xe.application_id = xte.application_id
		and xe.entity_id      = xte.entity_id
		and xte.entity_code       IN ('PURCHASE_ORDER')
		and xte.source_id_int_1   = PHA.po_header_id (+)
		and PHA.vendor_id = ps.vendor_id(+)
		and ps.party_id = hp.party_id(+)
		and gjl.code_combination_id = gcc.code_combination_id  
		and gjh.actual_flag = 'A'
		AND (GJH.STATUS IN (:P_POSTING_STATUS) OR COALESCE(:P_POSTING_STATUS,null) IS NULL)
		AND	(gjh.PERIOD_NAME IN (:P_PERIOD_NAME) OR COALESCE(:P_PERIOD_NAME,null) IS NULL)
		AND GL.NAME  = :P_LEDGER_NAME
		--Allow Multiselect on the following parameters
		AND	(GCC.SEGMENT1 IN (:P_FUND) OR COALESCE(:P_FUND,null) IS NULL)
		AND	(GCC.SEGMENT2 IN (:P_COST_CENTER) OR COALESCE(:P_COST_CENTER,null) IS NULL)
		AND	(GCC.SEGMENT3 IN (:P_COST_TYPE) OR COALESCE(:P_COST_TYPE,null) IS NULL)
		AND	(GCC.SEGMENT4 IN (:P_PROJECT) OR COALESCE(:P_PROJECT,null) IS NULL)
		AND	(GCC.SEGMENT5 IN (:P_ACTIVITY_TYPE) OR COALESCE(:P_ACTIVITY_TYPE,null) IS NULL)
		AND	(GCC.SEGMENT6 IN (:P_FERC) OR COALESCE(:P_FERC,null) IS NULL)
		AND	(GCC.SEGMENT7 IN (:P_BUDGET_CODE) OR COALESCE(:P_BUDGET_CODE,null) IS NULL)
		AND	(GCC.SEGMENT8 IN (:P_INTERCO) OR COALESCE(:P_INTERCO,null) IS NULL)		
		AND	(GJS.user_je_source_name IN (:P_JE_SOURCE_NAME) OR COALESCE(:P_JE_SOURCE_NAME,null) IS NULL)
		AND	(GJC.USER_JE_CATEGORY_NAME IN (:P_JE_CATEGORY_NAME) OR COALESCE(:P_JE_CATEGORY_NAME,null) IS NULL)
UNION
--Project Costing
SELECT 			GL.LEDGER_ID,
				GL.NAME LEDGER_NAME,
				GJH.JE_SOURCE,
				GJS.user_je_source_name JE_SOURCE_NAME,
				GJH.JE_CATEGORY,
				GJC.USER_JE_CATEGORY_NAME JE_GATEGORY_NAME,
				gjb.name GL_batch_name,
				GJH.NAME JOURNAL_NAME,
				GJl.DESCRIPTION JOURNAL_LINE_DESC,
				gjh.je_header_id,				
				GJL.JE_LINE_NUM,
				gjl.period_name,
				NVL(gjh.currency_code,GJL.currency_code) currency_code,
				DECODE (gjb.status,  'P', 'Posted',  'U', 'Unposted',  gjb.status) BATCH_STATUS,
				DECODE (gjh.status,  'P', 'Posted',  'U', 'Unposted',  gjh.status) JOURNAL_STATUS,
				DECODE (gjl.status,  'P', 'Posted',  'U', 'Unposted',  gjl.status) JE_LINE_STATUS,	
				to_char(gjh.default_effective_date,'MM/DD/YYYY HH24:MI:SS') JOURNAL_DATE,
				to_char(gjh.posted_date,'MM/DD/YYYY HH24:MI:SS')  Posted_Date,
				case when (xdl.ae_line_num IS NULL )
			THEN NVL(xal.accounted_dr,GJL.accounted_dr) 
			 ELSE xdl.unrounded_accounted_dr
			END ACCOUNTED_DR,
					case when (xdl.ae_line_num IS NULL )
				   THEN NVL(xal.accounted_cr,GJL.accounted_cr) 
			 ELSE xdl.unrounded_accounted_cr
			END ACCOUNTED_CR,
					case when (xdl.ae_line_num IS NULL )
				   THEN NVL(xal.entered_dr,GJL.entered_dr) 
			 ELSE xdl.unrounded_entered_dr
			END ENTERED_DR,
					case when (xdl.ae_line_num IS NULL )
				   THEN NVL(xal.entered_cr,GJL.entered_cr) 
			 ELSE xdl.unrounded_entered_cr
			END ENTERED_CR,
				gcc.segment1 GL_FUND,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,1, gcc.segment1) GL_FUND_DESC,
				GCC.SEGMENT2 GL_COST_CENTER,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,2, gcc.segment2) GL_COST_CENTER_DESC,
				GCC.SEGMENT3 GL_COST_TYPE,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,3, gcc.segment3) GL_COST_TYPE_DESC,
				GCC.SEGMENT4 GL_PROJECT,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,4, gcc.segment4) GL_PROJECT_DESC,
				GCC.SEGMENT5 GL_ACTIVITY_TYPE,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,5, gcc.segment5) GL_ACTIVITY_TYPE_DESC,
				GCC.SEGMENT6 GL_FERC,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,6, gcc.segment6) GL_FERC_DESC,
				GCC.SEGMENT7 GL_BUDGET_CODE,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,7, gcc.segment7) GL_BUDGET_CODE_DESC,
				GCC.SEGMENT8 GL_INTERCOMPANY,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,8, gcc.segment8) GL_INTERCOMPANY_DESC,
				GCC.SEGMENT9 GL_FUTURE1,
				GCC.SEGMENT10 GL_FUTURE2,				
				GJH.reversed_je_header_id,
				xal.application_id,
				xah.ae_header_id,
				xal.ae_line_num,				
				xal.ACCOUNTING_CLASS_CODE,
				XDL.TEMP_LINE_NUM XDL_TEMP_LINE_NUM, 
				XDL.SOURCE_DISTRIBUTION_TYPE XDL_SOURCE_DIST_TYPE,
				XDL.SOURCE_DISTRIBUTION_ID_NUM_1 XDL_SOURCE_DIST_ID_NUM_1,
				XDL.SOURCE_DISTRIBUTION_ID_NUM_2 XDL_SOURCE_DIST_ID_NUM_2,
				XDL.SOURCE_DISTRIBUTION_ID_CHAR_1 XDL_SOURCE_DIST_ID_CHAR_1,
				XDL.ref_ae_header_id XDL_REF_AE_HEADER_ID,
				XE.event_id XLA_EVENT_ID,
				XE.event_type_code XLA_EVENT_TYPE_CODE,
				xte.entity_ID XTE_ENTITY_ID,
				xte.entity_code XTE_ENTITY_CODE,
				XTE.SOURCE_ID_INT_1 XTE_SOURCE_ID_INT_1,
				XTE.SOURCE_ID_INT_2 XTE_SOURCE_ID_INT_2,
				XTE.SOURCE_ID_INT_3 XTE_SOURCE_ID_INT_3,
				XTE.source_id_char_1 XTE_SOURCE_ID_CHAR_1,
				XTE.source_id_char_2 XTE_SOURCE_ID_CHAR_2, 
				XTE.transaction_number XTE_TRANSACTION_NUMBER,
				NULL AR_CUSTOMER_NAME,    
				NULL AR_CUSTOMER_ACCOUNT,
				NULL AR_TRX_NUMBER,
				NULL AR_TRX_DATE,
				NULL AR_CASH_RCPT_NUM,
				NULL AR_CASH_RCPT_DATE,
				CASE 
                  -- This will populate Supplier Name with Employee Name for Expense Reports
					  WHEN peia.incurred_by_person_id IS NOT NULL AND peia.system_linkage_function = 'ER' THEN
							(SELECT PersonNameDPEO.display_name
							FROM PER_PERSON_NAMES_F_V PersonNameDPEO
							WHERE PersonNameDPEO.person_id = peia.incurred_by_person_id
							AND TRUNC(SYSDATE) BETWEEN PersonNameDPEO.effective_start_date AND NVL(PersonNameDPEO.Effective_end_date,TRUNC(SYSDATE)+1))
					  --
					  WHEN peia.vendor_id IS NOT NULL THEN 
							(SELECT HP.party_name
							FROM hz_parties HP,POZ_SUPPLIERS PS
							WHERE HP.party_id = PS.party_id
							AND PS.vendor_id = PEIa.vendor_id)
					  ELSE NULL
				END SUPPLIER_NAME,
				CASE 
                  -- This will populate Supplier Number with Employee Number for Expense Reports
                  WHEN peia.incurred_by_person_id IS NOT NULL AND peia.system_linkage_function = 'ER' 
                  THEN
                        (SELECT person_number
                        FROM PER_all_PEOPLE_F ppf
                        WHERE ppf.person_id = peia.incurred_by_person_id
                        AND TRUNC(SYSDATE) BETWEEN ppf.effective_start_date AND NVL(ppf.Effective_end_date,TRUNC(SYSDATE)+1))
                  --
                  WHEN peia.vendor_id IS NOT NULL THEN 
                        (SELECT PS.segment1
                        FROM POZ_SUPPLIERS PS
                        WHERE PS.vendor_id = PEIa.vendor_id)
                  --    
                  ELSE NULL
                  END supplier_number,
				CASE PTSt.user_transaction_source
                  WHEN 'Oracle Fusion Cost Management' THEN 
                        CASE ptdt.document_name
                              WHEN 'Purchase Receipt' THEN PEIa.DOC_REF_ID2
                              ELSE NULL
                 END   
                 WHEN 'Oracle Fusion Payables' THEN 
                    CASE ptdt.document_name
                              WHEN 'Supplier Invoice' THEN
                                    (SELECT poh.segment1 
                                     FROM       po_headers_all poh 
                                     WHERE  poh.po_header_id = PEIa.parent_header_id) 
                              ELSE NULL   
                        END   
                 ELSE NULL
		 END PO_NUMBER,
		 NULL PO_LINE_NUM,
		 NULL PO_DIST_LINE_NUM,
		 CASE
		    WHEN PTSt.user_transaction_source = 'Oracle Fusion Payables' THEN
							  (SELECT aip.invoice_num 
							   FROM ap_invoices_all aip 
							   WHERE aip.invoice_id = PEIa.original_header_id) 
		ELSE NULL          
		END INVOICE_NUM,
		NULL VOUCHER_NUM,
		NULL AP_INVOICE_SOURCE,
		NULL ORG_ID,
		NULL BU,
		NULL INVOICE_DATE,
		NULL INVOICE_LINE_NUM,
		NULL NVOICE_DIST_LINE_NUM,
		NULL PAYMENT_NUM,
		DECODE(PTSt.user_transaction_source,'Oracle Fusion Cost Management',DECODE(ptdt.document_name,'Purchase Receipt',PEIa.DOC_REF_ID3,NULL),NULL)  RECEIPT_NUMBER,
		NULL TRANSACTION_ID,   
		NULL ITEM_NUMBER,
		NULL ITEM_DESCRIPTION,
		pcdl.QUANTITY TRANSACTION_QUANTITY,
		PEIA.UNIT_OF_MEASURE TRANSACTION_UOM,     
		ppab.segment1 project_number,
                ppat.name project_name,
		ptcv.task_number,
		ptcv.task_name,
		pett.expenditure_type_name expenditure_type,
		pett.description EXPENDITURE_TYPE_DESC,
		hou.name EXPENDITURE_ORG_NAME,
		pcdl.line_num CDL_LINE_NUM,
		pec.expenditure_comment expenditure_comment,
		ptst.user_transaction_source PJC_TRANSACTION_SOURCE,
		ptdt.document_name PJC_DOCUMENT_TYPE,
		ptdet.doc_entry_name PJC_DOCUMENT_ENTRY, 
		peia.user_batch_name PJC_BATCH_NAME,
		CASE 
                WHEN peia.incurred_by_person_id IS NOT NULL AND peia.system_linkage_function IN ('ST','ER') THEN
                        (SELECT person_number
                        FROM PER_PEOPLE_F ppf
                        WHERE ppf.person_id = peia.incurred_by_person_id
                        AND TRUNC(SYSDATE) BETWEEN ppf.effective_start_date AND NVL(ppf.Effective_end_date,TRUNC(SYSDATE)+1))
                  ELSE NULL
                END employee_number, 
		CASE 
                  WHEN peia.incurred_by_person_id IS NOT NULL AND peia.system_linkage_function IN ('ST','ER') THEN
                        (SELECT PersonNameDPEO.display_name
                        FROM PER_PERSON_NAMES_F_V PersonNameDPEO
                        WHERE PersonNameDPEO.person_id = peia.incurred_by_person_id
                        AND TRUNC(SYSDATE) BETWEEN PersonNameDPEO.effective_start_date AND NVL(PersonNameDPEO.Effective_end_date,TRUNC(SYSDATE)+1))
                  ELSE NULL
		END employee_name,
				NULL OMS_Sales_Order,
				NULL OMS_Customer_PO,
				NULL source_code		
FROM 		 gl_je_lines gjl
			,gl_je_headers gjh
			,gl_je_batches gjb   
			,gl_import_references gir
			,xla_ae_lines xal
			,xla_ae_headers xah
			,xla_distribution_links xdl
			,xla_events xe
			,xla_transaction_entities xte			
	        ,pjc_cost_dist_lines_all pcdl
	        ,pjf_projects_all_b ppab
	        ,pjc_exp_items_all peia
	        ,pjf_projects_all_tl ppat
			,PJC_TASKS_CCW_V ptcv
			,PJF_EXP_TYPES_TL pett
			,PJC_EXP_COMMENTS pec
			,PJF_TXN_SOURCES_TL ptst
			,PJF_TXN_DOCUMENT_TL ptdt
			,PJF_TXN_DOC_ENTRY_TL ptdet
			,HR_ORGANIZATION_UNITS hou
			,GL_CODE_COMBINATIONS GCC
			,gl_je_sources GJS
			,gl_je_categories GJC
			,gl_ledgers gl
		WHERE 1=1
			and gjh.ledger_id    = gl.ledger_id
			and gjb.je_batch_id  = gjh.je_batch_id
			and gjh.je_header_id = gjl.je_header_id 
			and gjh.je_source    = gjs.je_source_name
			and gjh.je_category  = gjc.je_category_name
			and gjl.je_header_id = gir.je_header_id
			and gjl.je_line_num  = gir.je_line_num
			and gir.gl_sl_link_table = xal.gl_sl_link_table
			and gir.gl_sl_link_id    = xal.gl_sl_link_id
			and xal.application_id = xah.application_id
			and xal.ae_header_id   = xah.ae_header_id
			and xah.application_id = xe.application_id
			and xah.event_id       = xe.event_id 
			and xah.ae_header_id = xdl.ae_header_id(+)
			and xal.ae_line_num = xdl.ae_line_num(+)
			and xe.application_id = xte.application_id
			and xe.entity_id      = xte.entity_id
			and GJH.JE_SOURCE = 'Project Accounting'    
			--AND pcdl.expenditure_item_id(+) = xdl.source_distribution_id_num_1
			--AND pcdl.line_num(+) = xdl.source_distribution_id_num_2
			AND xte.source_id_int_1 = pcdl.expenditure_item_id(+)
			AND pcdl.expenditure_item_id =peia.expenditure_item_id(+)
			AND pcdl.expenditure_item_id = peia.expenditure_item_id(+)
			AND peia.project_id = ppab.project_id(+)
			AND ppab.project_id = ppat.project_id (+)
			AND peia.task_id    = ptcv.task_id(+)
			AND PEIA.org_id = PTCV.expenditure_org_id(+)
			and peia.expenditure_type_id = pett.expenditure_type_id(+)
			and peia.expenditure_organization_id = hou.organization_id(+)
			and peia.expenditure_item_id = pec.expenditure_item_id(+)
			and peia.transaction_source_id = ptst.transaction_source_id(+)
			and peia.document_id = ptdt.document_id(+)
			and peia.doc_entry_id = ptdet.doc_entry_id(+)
			and gjl.code_combination_id = gcc.code_combination_id  
			and gjh.actual_flag = 'A'
			AND (GJH.STATUS IN (:P_POSTING_STATUS) OR COALESCE(:P_POSTING_STATUS,null) IS NULL)
		    AND	(gjh.PERIOD_NAME IN (:P_PERIOD_NAME) OR COALESCE(:P_PERIOD_NAME,null) IS NULL)
			AND GL.NAME  = :P_LEDGER_NAME
			--Allow Multiselect on the following parameters
			AND	(GCC.SEGMENT1 IN (:P_FUND) OR COALESCE(:P_FUND,null) IS NULL)
			AND	(GCC.SEGMENT2 IN (:P_COST_CENTER) OR COALESCE(:P_COST_CENTER,null) IS NULL)
			AND	(GCC.SEGMENT3 IN (:P_COST_TYPE) OR COALESCE(:P_COST_TYPE,null) IS NULL)
			AND	(GCC.SEGMENT4 IN (:P_PROJECT) OR COALESCE(:P_PROJECT,null) IS NULL)
			AND	(GCC.SEGMENT5 IN (:P_ACTIVITY_TYPE) OR COALESCE(:P_ACTIVITY_TYPE,null) IS NULL)
			AND	(GCC.SEGMENT6 IN (:P_FERC) OR COALESCE(:P_FERC,null) IS NULL)
			AND	(GCC.SEGMENT7 IN (:P_BUDGET_CODE) OR COALESCE(:P_BUDGET_CODE,null) IS NULL)
			AND	(GCC.SEGMENT8 IN (:P_INTERCO) OR COALESCE(:P_INTERCO,null) IS NULL)			
			AND	(GJS.user_je_source_name IN (:P_JE_SOURCE_NAME) OR COALESCE(:P_JE_SOURCE_NAME,null) IS NULL)
			AND	(GJC.USER_JE_CATEGORY_NAME IN (:P_JE_CATEGORY_NAME) OR COALESCE(:P_JE_CATEGORY_NAME,null) IS NULL)
UNION
-- Direct GL journal
SELECT 			GL.LEDGER_ID,
				GL.NAME LEDGER_NAME,
				GJH.JE_SOURCE,
				GJS.user_je_source_name JE_SOURCE_NAME,
				GJH.JE_CATEGORY,
				GJC.USER_JE_CATEGORY_NAME JE_GATEGORY_NAME,
				gjb.name GL_batch_name,
				GJH.NAME JOURNAL_NAME,
				GJl.DESCRIPTION JOURNAL_LINE_DESC,
				gjh.je_header_id,				
				GJL.JE_LINE_NUM,
				gjl.period_name,
				NVL(gjh.currency_code,GJL.currency_code) currency_code,
				DECODE (gjb.status,  'P', 'Posted',  'U', 'Unposted',  gjb.status) BATCH_STATUS,
				DECODE (gjh.status,  'P', 'Posted',  'U', 'Unposted',  gjh.status) JOURNAL_STATUS,
				DECODE (gjl.status,  'P', 'Posted',  'U', 'Unposted',  gjl.status) JE_LINE_STATUS,	
				to_char(gjh.default_effective_date,'MM/DD/YYYY HH24:MI:SS') JOURNAL_DATE,
				to_char(gjh.posted_date,'MM/DD/YYYY HH24:MI:SS')  Posted_Date,
				case when (xdl.ae_line_num IS NULL )
			THEN NVL(xal.accounted_dr,GJL.accounted_dr) 
			 ELSE xdl.unrounded_accounted_dr
			END ACCOUNTED_DR,
					case when (xdl.ae_line_num IS NULL )
				   THEN NVL(xal.accounted_cr,GJL.accounted_cr) 
			 ELSE xdl.unrounded_accounted_cr
			END ACCOUNTED_CR,
					case when (xdl.ae_line_num IS NULL )
				   THEN NVL(xal.entered_dr,GJL.entered_dr) 
			 ELSE xdl.unrounded_entered_dr
			END ENTERED_DR,
					case when (xdl.ae_line_num IS NULL )
				   THEN NVL(xal.entered_cr,GJL.entered_cr) 
			 ELSE xdl.unrounded_entered_cr
			END ENTERED_CR,
				gcc.segment1 GL_FUND,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,1, gcc.segment1) GL_FUND_DESC,
				GCC.SEGMENT2 GL_COST_CENTER,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,2, gcc.segment2) GL_COST_CENTER_DESC,
				GCC.SEGMENT3 GL_COST_TYPE,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,3, gcc.segment3) GL_COST_TYPE_DESC,
				GCC.SEGMENT4 GL_PROJECT,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,4, gcc.segment4) GL_PROJECT_DESC,
				GCC.SEGMENT5 GL_ACTIVITY_TYPE,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,5, gcc.segment5) GL_ACTIVITY_TYPE_DESC,
				GCC.SEGMENT6 GL_FERC,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,6, gcc.segment6) GL_FERC_DESC,
				GCC.SEGMENT7 GL_BUDGET_CODE,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,7, gcc.segment7) GL_BUDGET_CODE_DESC,
				GCC.SEGMENT8 GL_INTERCOMPANY,
				gl_flexfields_pkg.get_description_sql(gcc.chart_of_accounts_id,8, gcc.segment8) GL_INTERCOMPANY_DESC,
				GCC.SEGMENT9 GL_FUTURE1,
				GCC.SEGMENT10 GL_FUTURE2,				
				GJH.reversed_je_header_id,
				xal.application_id,
				xah.ae_header_id,
				xal.ae_line_num,				
				xal.ACCOUNTING_CLASS_CODE,
				XDL.TEMP_LINE_NUM XDL_TEMP_LINE_NUM, 
				XDL.SOURCE_DISTRIBUTION_TYPE XDL_SOURCE_DIST_TYPE,
				XDL.SOURCE_DISTRIBUTION_ID_NUM_1 XDL_SOURCE_DIST_ID_NUM_1,
				XDL.SOURCE_DISTRIBUTION_ID_NUM_2 XDL_SOURCE_DIST_ID_NUM_2,
				XDL.SOURCE_DISTRIBUTION_ID_CHAR_1 XDL_SOURCE_DIST_ID_CHAR_1,
				XDL.ref_ae_header_id XDL_REF_AE_HEADER_ID,
				XE.event_id XLA_EVENT_ID,
				XE.event_type_code XLA_EVENT_TYPE_CODE,
				xte.entity_ID XTE_ENTITY_ID,
				xte.entity_code XTE_ENTITY_CODE,
				XTE.SOURCE_ID_INT_1 XTE_SOURCE_ID_INT_1,
				XTE.SOURCE_ID_INT_2 XTE_SOURCE_ID_INT_2,
				XTE.SOURCE_ID_INT_3 XTE_SOURCE_ID_INT_3,
				XTE.source_id_char_1 XTE_SOURCE_ID_CHAR_1,
				XTE.source_id_char_2 XTE_SOURCE_ID_CHAR_2, 
				XTE.transaction_number XTE_TRANSACTION_NUMBER,
				NULL AR_CUSTOMER_NAME,    
				NULL AR_CUSTOMER_ACCOUNT,
				NULL AR_TRX_NUMBER,
				NULL AR_TRX_DATE,
				NULL AR_CASH_RCPT_NUM,
				NULL AR_CASH_RCPT_DATE,
				NULL SUPPLIER_NAME,
				NULL SUPPLIER_NUMBER,
				NULL PO_NUMBER,
				NULL PO_LINE_NUM,
				NULL PO_DIST_LINE_NUM,
				NULL INVOICE_NUM,
				NULL VOUCHER_NUM,
				NULL AP_INVOICE_SOURCE,
				NULL ORG_ID,
				NULL BU,
				NULL INVOICE_DATE,
				NULL INVOICE_LINE_NUM,
				NULL NVOICE_DIST_LINE_NUM,
				NULL PAYMENT_NUM,
				NULL RECEIPT_NUMBER,
				NULL TRANSACTION_ID,
				NULL ITEM_NUMBER,
				NULL ITEM_DESCRIPTION,
       	NULL TRANSACTION_QUANTITY,
				NULL TRANSACTION_UOM,
				NULL project_number,
				NULL project_name,
				NULL task_number,
				NULL task_name,
				NULL expenditure_type,
				NULL EXPENDITURE_TYPE_DESC,
				NULL EXPENDITURE_ORG_NAME,
				NULL CDL_LINE_NUM,
				NULL expenditure_comment,
				NULL PJC_TRANSACTION_SOURCE,
				NULL PJC_DOCUMENT_TYPE,
				NULL PJC_DOCUMENT_ENTRY, 
				NULL PJC_BATCH_NAME,
				NULL employee_number, 
				NULL employee_name,
				NULL OMS_Sales_Order,
				NULL OMS_Customer_PO,
				NULL source_code				
FROM 		 gl_je_lines gjl
			,gl_je_headers gjh
			,gl_je_batches gjb   
			,gl_import_references gir
			,xla_ae_lines xal
			,xla_ae_headers xah
			,xla_distribution_links xdl
			,xla_events xe
			,xla_transaction_entities xte			
			,GL_CODE_COMBINATIONS GCC
			,gl_je_sources GJS
			,gl_je_categories GJC
			,gl_ledgers gl
WHERE 1=1
		and gjh.ledger_id    = gl.ledger_id
		and gjb.je_batch_id  = gjh.je_batch_id
		and gjh.je_header_id = gjl.je_header_id 
		and gjh.je_source    = gjs.je_source_name
		and gjh.je_category  = gjc.je_category_name
		and gjl.je_header_id = gir.je_header_id(+)
		and gjl.je_line_num  = gir.je_line_num(+)
		and gir.gl_sl_link_table = xal.gl_sl_link_table(+)
		and gir.gl_sl_link_id    = xal.gl_sl_link_id(+)
		and xal.application_id = xah.application_id(+)
		and xal.ae_header_id   = xah.ae_header_id(+)
		and xah.application_id = xe.application_id(+)
		and xah.event_id       = xe.event_id (+)
		and xah.ae_header_id = xdl.ae_header_id(+)
		and xal.ae_line_num = xdl.ae_line_num(+)
		and xe.application_id = xte.application_id(+)
		and xe.entity_id      = xte.entity_id(+)
		and (GJS.user_je_source_name not in ('Payables','Project Accounting','Projects','Receipt Accounting','Cost Accounting','Receivables')
		    OR
	               ((GJS.user_je_source_name in ('Payables','Project Accounting','Projects','Receipt Accounting','Cost Accounting','Receivables')
		     AND gjh.REVERSED_JE_HEADER_ID is not null)
		    )		
		    )
		and gjh.actual_flag = 'A'
		and gjl.code_combination_id = gcc.code_combination_id 
		AND (GJH.STATUS IN (:P_POSTING_STATUS) OR COALESCE(:P_POSTING_STATUS,null) IS NULL)			
		AND	(gjh.PERIOD_NAME IN (:P_PERIOD_NAME) OR COALESCE(:P_PERIOD_NAME,null) IS NULL)
		AND GL.NAME  = :P_LEDGER_NAME
		--Allow Multiselect on the following parameters
		AND	(GCC.SEGMENT1 IN (:P_FUND) OR COALESCE(:P_FUND,null) IS NULL)
		AND	(GCC.SEGMENT2 IN (:P_COST_CENTER) OR COALESCE(:P_COST_CENTER,null) IS NULL)
		AND	(GCC.SEGMENT3 IN (:P_COST_TYPE) OR COALESCE(:P_COST_TYPE,null) IS NULL)
		AND	(GCC.SEGMENT4 IN (:P_PROJECT) OR COALESCE(:P_PROJECT,null) IS NULL)
		AND	(GCC.SEGMENT5 IN (:P_ACTIVITY_TYPE) OR COALESCE(:P_ACTIVITY_TYPE,null) IS NULL)
		AND	(GCC.SEGMENT6 IN (:P_FERC) OR COALESCE(:P_FERC,null) IS NULL)
		AND	(GCC.SEGMENT7 IN (:P_BUDGET_CODE) OR COALESCE(:P_BUDGET_CODE,null) IS NULL)
		AND	(GCC.SEGMENT8 IN (:P_INTERCO) OR COALESCE(:P_INTERCO,null) IS NULL)		
		AND	(GJS.user_je_source_name IN (:P_JE_SOURCE_NAME) OR COALESCE(:P_JE_SOURCE_NAME,null) IS NULL)
		AND	(GJC.USER_JE_CATEGORY_NAME IN (:P_JE_CATEGORY_NAME) OR COALESCE(:P_JE_CATEGORY_NAME,null) IS NULL)
) main
WHERE 1=1
