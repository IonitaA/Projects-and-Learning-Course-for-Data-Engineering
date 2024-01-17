import pandas as pd
import tkinter as tk
from tkinter import filedialog,messagebox
import win32com.client as win32
import re
import os
import datetime

class SapGui():

    def __init__(self):
        self.unique_FM = []

    def connect_sap(self):
        self.SapGuiAuto  = win32.GetObject("SAPGUI")
        application = self.SapGuiAuto.GetScriptingEngine
        self.connection = application.Children(0)
        self.session = self.connection.Children(0)

    def root_to_create_FM(self):
        shell = self.session.findById("wnd[0]/usr/cntlIMAGE_CONTAINER/shellcont/shell/shellcont[0]/shell")
        shell.expandNode("Root")
        shell.expandNode("0000000080")
        shell.expandNode("0000000068")
        shell.selectedNode = "0000000082"
        shell.topNode = "Favo"
        shell.doubleClickNode("0000000082")

    def create_FM(self,Coll_A,unique_AX):
        for i in unique_AX:
            if i != None:
                self.session.findById("wnd[0]/usr/txtP_LIB").text = Coll_A
                self.session.findById("wnd[0]/usr/ctxtP_FICDEC").text = i
                self.session.findById("wnd[0]/usr/btnBUT1").press()
                text = self.session.findById("wnd[1]/usr/txtMESSTXT1").text
                self.session.findById("wnd[1]").close()
                numbers = re.findall(r'\d+', text)
                self.unique_FM.append(int(numbers[0]))
        self.session.findById("wnd[0]/tbar[0]/btn[3]").press()

    def root_to_valide_csv(self):
        shell=self.session.findById("wnd[0]/usr/cntlIMAGE_CONTAINER/shellcont/shell/shellcont[0]/shell")
        shell.expandNode("0000000094")
        shell.selectedNode = "0000000106"
        shell.topNode = "Favo"
        shell.doubleClickNode("0000000106")

    def validate_csv(self,directory):
        location_template_csv = directory + '/Fichier Compilation.csv'
        location_template_txt = directory + '/Fichier Compilation.txt'
        self.session.findById("wnd[0]/usr/radP_LOCAL").select()
        self.session.findById("wnd[0]/usr/ctxtP_FENTRE").text = location_template_csv
        self.session.findById("wnd[0]/usr/ctxtP_FLOG").text = location_template_txt 
        self.session.findById("wnd[0]/tbar[1]/btn[8]").press()
        self.session.findById("wnd[0]/tbar[0]/btn[3]").press()

    def root_to_SQ00(self):
        self.session.findById("wnd[0]/tbar[0]/okcd").text = "sq00"
        self.session.findById("wnd[0]").sendVKey (0)
        self.session.findById("wnd[0]/usr/cntlGRID_CONT0050/shellcont/shell").selectedRows = "13"
        self.session.findById("wnd[0]/tbar[1]/btn[8]").press() 
        self.session.findById("wnd[0]/usr/btn%_SP$00003_%_APP_%-VALU_PUSH").press()

    def refernces_to_notpad_data(self,directory,list_ref):
        
        # add referinces
        for ref in list_ref:
            self.session.findById("wnd[1]/usr/tabsTAB_STRIP/tabpSIVA/ssubSCREEN_HEADER:SAPLALDB:3010/tblSAPLALDBSINGLE/txtRSCSEL-SLOW_I[1,0]").text = ref
            if ref != list_ref[-1]:
                self.session.findById("wnd[1]/tbar[0]/btn[13]").press() # add a new line in clipboard for a new referince
        
        self.session.findById("wnd[1]/tbar[0]/btn[8]").press() #validate in clipboard
        self.session.findById("wnd[0]/tbar[1]/btn[8]").press() #validate push

        self.session.findById("wnd[0]/tbar[1]/btn[45]").press()
        self.session.findById("wnd[1]/tbar[0]/btn[0]").press()
        self.session.findById("wnd[1]/usr/ctxtDY_PATH").text = directory #path
        self.session.findById("wnd[1]/usr/ctxtDY_FILENAME").text = "export_reference_notpad.txt" #name document

        self.session.findById("wnd[1]/tbar[0]/btn[0]").press()

        self.session.findById("wnd[0]/tbar[0]/btn[12]").press() # red button back
        self.session.findById("wnd[0]/tbar[0]/btn[12]").press()
        self.session.findById("wnd[0]/tbar[0]/btn[12]").press()

    def process_Result_dataframe(self,res,Coll_A,Col_ficdec_df_FNAV):
        unique_AX = pd.Series(Col_ficdec_df_FNAV).unique()
        self.create_FM(Coll_A, unique_AX)
        mapping = dict(zip(unique_AX, self.unique_FM))
        res.iloc[:, 2] = pd.Series(Col_ficdec_df_FNAV).map(mapping)
        return res

def create_fictech_series():
    YEAR = datetime.datetime.now().year
    return str(YEAR)[-2:]+"HV"

def process_notepad_file():
    root = tk.Tk()
    root.withdraw()
    file_path = filedialog.askopenfilename(filetypes=[('Text Files', '*.txt')])
    with open(file_path, 'r') as f:
        data = f.read()
    lines = data.strip().split('\n')
    data = [line.strip().split(';') for line in lines if line.strip()]
    df = pd.DataFrame(data)

    return df,file_path

def process_file(df,input_file):
    C_rows = df[df[1] == 'C']
    M_rows = df[df[1] == 'M']
    R_rows = df[df[1] == 'R']
    

    directory_FNAV = os.path.dirname(input_file)
    base_name_FNAV = os.path.basename(input_file)
    file_name_FNAV, _ = os.path.splitext(base_name_FNAV)
    
    if not C_rows.empty:
        C_rows = C_rows.iloc[:, 2:]
        C_rows = C_rows.reset_index(drop=True)
        C_rows.columns = range(C_rows.shape[1])
        new_file_name_C = directory_FNAV + "/" + file_name_FNAV + "_C.txt"
        C_rows.to_csv(new_file_name_C, sep=';', index=False, header=False)
    
    if not M_rows.empty:
        M_rows = M_rows.iloc[:, 2:]
        M_rows = M_rows.reset_index(drop=True)
        M_rows.columns = range(M_rows.shape[1])
        new_file_name_M = directory_FNAV + "/" + file_name_FNAV + "_M.txt"
        M_rows.to_csv(new_file_name_M, sep=';', index=False, header=False)

    if not R_rows.empty:
        R_rows = R_rows.iloc[:, 2:]
        R_rows = R_rows.reset_index(drop=True)
        R_rows.columns = range(R_rows.shape[1])
        new_file_name_R = directory_FNAV + "/" + file_name_FNAV + "_R.txt"
        R_rows.to_csv(new_file_name_R, sep=';', index=False, header=False)
        
    return C_rows, M_rows

def process_dataframe_for_C_rows(df_c):
        df_c.iloc[:, 0] = df_c.iloc[:, 4]
        
        return df_c

def prelucrate_reference_notpad_to_valid(directory):
    Path = directory + "/" + "export_reference_notpad.txt"
    with open(Path, "r") as file:
        lines = file.readlines()

    start_line = 0
    for i, line in enumerate(lines):
        if line.startswith("|Numéro article PR"):
            start_line = i + 2
            break

    lines = lines[start_line:]

    for i, line in enumerate(lines):
        if line.startswith("|"):
            start_line = i
            break

    lines = lines[start_line:]        
    lines = lines[:-1] 

    data = []
    current_row = []
    
    for line in lines:
        if line.startswith("|"):
            data.append(current_row)
            current_row = []
            current_row.extend([cell.strip() for cell in line.strip().split("|")])
        else:
            current_row.pop()
            current_row.append(line.strip().split("|")[0])
            current_row.append('')
    data.append(current_row)
    del data[0]
    
    df = pd.DataFrame(data)
    df = df.iloc[:, 1:-1]

    Path = directory + "/" + "export_reference_notpad_modelat.txt"

    df.to_csv(Path, sep=';', index=False, header=False)



def process_dataframe_for_M_rows(df_m, directory_FNAV_m):
    path_excel_SQ00 = directory_FNAV_m + "/" + "export_reference_notpad_modelat.txt"
    with open(path_excel_SQ00, 'r') as f:
        data = f.read()
    lines = data.strip().split('\n')
    data = [line.strip().split(';') for line in lines if line.strip()]
    excel_SQ00 = pd.DataFrame(data)
    list_of_ficdec_series =["24AH", "24AI", "24AP", "24HV", "24VI", "24PL", "23HV", "23VI", "23PL","23AH", "23AI", "23AP", "CORS", "AMES", "PRES", "RPXX", "RPXI", "RPPL","RPAH", "RPAI", "RPAP", "CM23", "CI23", "PS23", "DQ23", "QA23", "QS23","2050", "OPEL", "OPEN", "OPER", "OPPN", "OPPR", "OPES", "OPEU", "OPER","OVBH", "OVBI", "INSH", "INSI", "INSA", "OVAV", "CHNB", "CHTE", "CHAU","CHSU", "CHVU", "CPAU", "MALB", "MERB", "MERM", "MESU", "RUSV", "KALB","TURM", "IDAU", "IDAI", "IDVH", "IDVI", "IDNH", "IDNI", "FCAV", "FJHV","FJVI", "BPBR", "BPUS", "ACIK", "ACMK", "ACCS", "ACPS", "ACHV", "TRKA","RUSA", "AIND", "AINC", "PKIN", "PMKO", "PRMK", "FORW", "PNEU", "PNES","PNEE", "PNEW", "PNEH", "FILI", "EUI2", "EURI", "EURB", "EURC", "EURU","EURP", "EURT", "ERT2", "EURA", "EURD", "ERMQ", "GLIC", "BOLK", "IAMK","IAMX", "IAMY", "MBPR", "TOLH", "TOLI", "TEXT", "PPWT", "PNRS", "BATS","BATT", "REPA", "OUTI", "OUSP", "GMST", "P1ST", "P1SI", "P1SP", "P1SA","K9ST", "K9SI", "K9SP", "K9SA", "K9OH", "K9OI", "K0ST", "K0ME", "X2ME","B3PS", "B0ST", "BOLO"]


    num_columns = len(df_m.columns) - 1  # obținem indexul ultimei coloane
    last_digit_for_year = str(datetime.datetime.now().year)[-2:]


    for i in range(len(df_m)):
        for j in range(len(df_m.columns)):

            cell_df_m = df_m.iloc[i, j]
            cell_excel_SQ00 = excel_SQ00.iloc[i, j]

            # nu se modifica elementele din coloana date_ac/date_ap 
            if j == 10 or j == 11:
                if cell_excel_SQ00 == '' and cell_df_m != '' and cell_df_m != '00000000':
                    excel_SQ00.iloc[i, j] = df_m.iloc[i, j]
                continue
     
            # Verificăm dacă celula conține "#"
            if "#" in str(cell_df_m):
                excel_SQ00.iloc[i, j] = ""

            elif j == 47:
                # regula 3
                if cell_df_m == "2100":
                    #DATE_AC
                    if df_m.iloc[i, 10] != '':
                        excel_SQ00.iloc[i, 10] = '21000101'
                    else:
                        excel_SQ00.iloc[i, 10] = ''
                    #DATE_AP
                    if df_m.iloc[i, 11] != '':
                        excel_SQ00.iloc[i, 11] = '21000101'
                    else:
                        excel_SQ00.iloc[i, 11] = ''
                    #ADD NEW FICTEC
                    excel_SQ00.iloc[i, j]  = '2100'

                # regula 4
                elif cell_df_m == "0000":
                    #ADD NEW FICTEC
                    excel_SQ00.iloc[i, j]  = '0000'

                #aici cell_df_m != "23*"
                # regula ficdec diferit de forma "ultimele doua cifere din an + HV"

                elif last_digit_for_year in cell_df_m[:2] or cell_df_m in list_of_ficdec_series:
                    #coloana DATA_AC
                    if df_m.iloc[i, 10] != '' and df_m.iloc[i, 10] != '00000000':
                        excel_SQ00.iloc[i, 10] = df_m.iloc[i, 10]
                    #coloana DATA_AP
                    if df_m.iloc[i, 11] != '' and df_m.iloc[i, 11] != '00000000':
                        excel_SQ00.iloc[i, 11] = df_m.iloc[i, 11]

                    excel_SQ00.iloc[i, j]  = df_m.iloc[i, j]

                #Adaugarea noului ficdec in cazul in care acesta exista in export si este diferit de cel curent
                elif cell_excel_SQ00 != cell_df_m and cell_df_m != '':
                    excel_SQ00.iloc[i, j] = cell_df_m


            # eliminarea observatiilor curente si punerea de observatii noi (care este localizata pe ultima coloana)
            elif j == num_columns:  # verificăm dacă suntem pe ultima coloană
                if  cell_excel_SQ00 == cell_df_m or cell_df_m == '':
                    excel_SQ00.iloc[i, j] = ""
                elif cell_excel_SQ00 != cell_df_m and cell_df_m != '':
                    excel_SQ00.iloc[i, j] = cell_df_m

            # Punerea informatilor in excel daca nu sunt reguli de tratat pentru acest set de celule
            elif cell_excel_SQ00 != cell_df_m and cell_df_m != '':
                excel_SQ00.iloc[i, j] = cell_df_m
           
    return excel_SQ00

def notpade_to_csv(DF,Directory):
    path_for_CSV = Directory + "/"+'Fichier Compilation.csv'
    DF.to_csv(path_for_CSV, sep=';', index=False, header=False)

def create_export(coll_a,path):
    directory = os.path.dirname(path)
    new_path = directory + "/" + 'Fichier Compilation.txt'
    with open(new_path, 'r') as f:
        data = f.read()
    lines = data.strip().split('\n')
    data = [line.strip().split(';') for line in lines if line.strip()]
    df = pd.DataFrame(data)
    df.insert(0, '', coll_a)
    df = df.iloc[:, :-1]
    new_file_name = path.replace('export', 'log')
    df.to_csv(new_file_name, sep=';', index=False, header=False)

def show_error(title, message):
    root = tk.Tk()
    root.withdraw()  
    messagebox.showerror(title, message)  
    root.destroy() 

def show_info(title, message):
    root = tk.Tk()
    root.withdraw()  
    messagebox.showinfo(title, message)  
    root.destroy() 

def main():
    try:
        df_FNAV,Path_FNAV = process_notepad_file()
    except FileNotFoundError:
        show_error("Error", "No file has been selected")
        return
    
    if os.stat(Path_FNAV).st_size == 0:
        show_error("Error", "The file is empty")
        return

    if df_FNAV.shape[1] != 81:
        show_error("Error", "The required columns do not exist")
        return
    
    df_FNAV = df_FNAV.sort_values(by=6, ascending=True)
    df_FNAV = df_FNAV.reset_index(drop=True)
    
    col_ficdec_df_FNAV = df_FNAV[49].tolist()
    ficdec_null = create_fictech_series()
    col_ficdec_df_FNAV = [ficdec_null if elem == '' else elem for elem in col_ficdec_df_FNAV]
    
    
    
    

    Coll_A = "fnav " + str(df_FNAV.iloc[0,0])
    Coll_a = str(df_FNAV.iloc[0,0])


    c_rows, m_rows = process_file(df_FNAV,Path_FNAV)

    list_referinces = m_rows[4].tolist()

    Directory_FNAV = os.path.dirname(Path_FNAV)

    sap_gui = SapGui()

    try:
        sap_gui.connect_sap()
    except Exception as e:
        show_error("Error", f"An error occurred while connecting to SAP: {e}")
        return
    
    if not c_rows.empty:
        c_rows = process_dataframe_for_C_rows(c_rows)
    
    if not m_rows.empty:    
        sap_gui.root_to_SQ00()
        sap_gui.refernces_to_notpad_data(Directory_FNAV,list_referinces)
        prelucrate_reference_notpad_to_valid(Directory_FNAV)
        m_rows = process_dataframe_for_M_rows(m_rows,Directory_FNAV)

    if not c_rows.empty and not m_rows.empty:
        df_result = pd.concat([c_rows, m_rows])
        df_result = df_result.reset_index(drop=True)
	
    
    if not c_rows.empty and m_rows.empty:
        df_result = c_rows

    if c_rows.empty and not m_rows.empty:
        df_result = m_rows

       
    df_result = df_result.sort_values(by=4, ascending=True)
    df_result = df_result.reset_index(drop=True)

    #m_rows.to_csv("m_rows.txt", sep=';', header=False, index=False)
    #df_result.to_csv("df_result.txt", sep=';', header=False, index=False)


    sap_gui.root_to_create_FM()
    df_result = sap_gui.process_Result_dataframe(df_result,Coll_A,col_ficdec_df_FNAV)

    notpade_to_csv(df_result,Directory_FNAV)

    sap_gui.root_to_valide_csv()

    sap_gui.validate_csv(Directory_FNAV)

    create_export(Coll_a,Path_FNAV)

    show_info("Succes", "The program has finished running")
    


if __name__ == "__main__":
    main()