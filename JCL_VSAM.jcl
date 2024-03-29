//TSOBA19A JOB 0000,'DEFVSAM',MSGCLASS=Q,MSGLEVEL=(1,1),             
//         NOTIFY=&SYSUID,CLASS=A,REGION=0M,                         
//         RESTART=*                                                 
//*******************************************************************
//* FIRST WE DELETE THE VSAM                                        *
//*******************************************************************
//STEP10   EXEC PGM=IDCAMS                                           
//SYSPRINT DD  SYSOUT=*                                              
//SYSIN    DD  *                                                     
   IF MAXCC = 0 THEN -                                               
   DELETE TSOBA19.VSAM.KSDSFILE CLUSTER PURGE                        
/*                                                                   
//*                                                                  
//*******************************************************************
//* THEN WE DEFINE THE VSAM                                         *
//*******************************************************************
//STEP20 EXEC PGM=IDCAMS                                             
//SYSPRINT DD  SYSOUT=*                                              
//SYSIN    DD  *                                                     
   DEFINE CLUSTER (NAME(TSOBA19.VSAM.KSDSFILE)  -                    
   INDEXED                                 -                         
   RECSZ(80 80)                            -                         
   TRACKS(1,1)                             -                         
   KEYS(6 0)                              -                          
   CISZ(4096)                              -                         
   FREESPACE(3 3))                        -                          
   DATA (NAME(TSOBA19.VSAM.KSDSFILE.DATA))  -                        
      INDEX (NAME(TSOBA19.VSAM.KSDSFILE.INDEX))                      
/*                                                                   
//******************************************************************
//* - THE SORT PARAM IS (COL_START,COL_END)                        * 
//******************************************************************
//STEP30 EXEC PGM=IDCAMS                                             
//SYSPRINT DD  SYSOUT=*                                              
//SYSIN    DD  *                                                     
   DELETE TSOBA19.FILE.MYDATA1.SORTED                                
/*                                                                   
//*                                                                  
//TOOLRUN EXEC PGM=ICETOOL,REGION=1024K                              
//INDD     DD  DSN=TSOBA19.FILE.MYDATA1,DISP=SHR                     
//OUTDD    DD  DSN=TSOBA19.FILE.MYDATA1.SORTED,                      
//             DISP=(NEW,CATLG,DELETE),                              
//             LIKE=TSOBA19.FILE.MYDATA1                             
//TOOLIN   DD  *                                                     
   SORT FROM(INDD) TO(OUTDD) USING(CTL1)                             
/*                                                                   
//CTL1CNTL DD  *           
   SORT FIELDS=(1,6,CH,A)                                            
//*                                                                  
//TOOLMSG  DD  SYSOUT=*                                              
//DFSMSG   DD  SYSOUT=*                                              
//*                                                                  
//*******************************************************************
//* THEN WE POPULATE THE VSAM                                       *
//*******************************************************************
//STEP40 EXEC PGM=IDCAMS                                             
//INPUT    DD  DSN=TSOBA19.FILE.MYDATA1.SORTED,DISP=SHR              
//OUTPUT   DD  DSN=TSOBA19.VSAM.KSDSFILE,DISP=SHR                    
//SYSPRINT DD  SYSOUT=*                                              
//SYSIN    DD  *                                                     
   IF MAXCC = 0 THEN -                                               
        REPRO -                                                      
              INFILE(INPUT) -                                        
              OUTFILE(OUTPUT)                                        
/*              
