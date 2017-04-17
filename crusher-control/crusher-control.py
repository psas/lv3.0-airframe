import u3
import time
import Tkinter as tk

REG_AIN0 = 0
REG_DAC0 = 5000

class CrusherApp(tk.Frame):
  def __init__(self, master=None):
    tk.Frame.__init__(self,master)
    self.grid()

    self.output_file = None

    self.output_voltage = 0.0
    self.set_output_voltage(self.output_voltage)
    self.input_voltage = labjack.readRegister(REG_AIN0)
    self.max_voltage = 5.0
    self.min_voltage = 0.0
    self.step_voltage = 0.005
    self.delay_time = 1

    self.ramp_enable = False

    self.file_var = tk.StringVar(value="output.csv")
    self.output_var = tk.StringVar(value=str(self.output_voltage))
    self.input_var = tk.StringVar(value=str(self.input_voltage))
    self.max_var = tk.StringVar(value=str(self.max_voltage))
    self.min_var = tk.StringVar(value=str(self.min_voltage))
    self.step_var = tk.StringVar(value=str(self.step_voltage))
    self.delay_var = tk.StringVar(value=str(self.delay_time))

    self.createUI()
    
    self.ramp_timer_id = self.after(self.delay_time*1000,self.ramp_timer_tick)
    self.csv_timer_id = self.after(100,self.csv_timer_tick)

  def createUI(self):
    self.file_entry = tk.Entry(self, textvariable=self.file_var)
    self.record_button = tk.Button(self,text="Record File", command=self.record_file)
    self.close_button = tk.Button(self,text="Close File", command=self.close_file)
    self.inc_0_button = tk.Button(self,text="+ 0.005", command=self.inc_0)
    self.dec_0_button = tk.Button(self,text="- 0.005", command=self.dec_0)
    self.inc_1_button = tk.Button(self,text="+ 0.01", command=self.inc_1)
    self.dec_1_button = tk.Button(self,text="- 0.01", command=self.dec_1)
    self.inc_2_button = tk.Button(self,text="+ 0.1", command=self.inc_2)
    self.dec_2_button = tk.Button(self,text="- 0.1", command=self.dec_2)
    self.output_entry = tk.Entry(self, disabledforeground="black", state=tk.DISABLED, textvariable=self.output_var)
    self.input_entry = tk.Entry(self, disabledforeground="black", state=tk.DISABLED, textvariable=self.input_var)
    self.max_entry = tk.Entry(self, textvariable=self.max_var)
    self.min_entry = tk.Entry(self, textvariable=self.min_var)
    self.step_entry = tk.Entry(self, textvariable=self.step_var)
    self.delay_entry = tk.Entry(self, textvariable=self.delay_var)
    self.run_button = tk.Button(self,text="Run", command=self.run_ramp)
    self.stop_button = tk.Button(self,text="Stop", command=self.stop_ramp)
    self.zero_button = tk.Button(self,text="Zero Output Voltage", command=self.zero_output)
    self.full_button = tk.Button(self,text="Max Output Voltage", command=self.max_output)

    row = 0
    tk.Label(self,text="CSV Output File").grid(row=row,column=0,columnspan=2,sticky=tk.E+tk.W)
    row+=1
    self.file_entry.grid(row=row,column=0,columnspan=2,sticky=tk.E+tk.W)
    row+=1
    self.record_button.grid(row=row,column=0,sticky=tk.E+tk.W)
    self.close_button.grid(row=row,column=1,sticky=tk.E+tk.W)

    row+=1
    self.dec_0_button.grid(row=row,column=0,sticky=tk.E+tk.W)
    self.inc_0_button.grid(row=row,column=1,sticky=tk.E+tk.W)
    row+=1
    self.dec_1_button.grid(row=row,column=0,sticky=tk.E+tk.W)
    self.inc_1_button.grid(row=row,column=1,sticky=tk.E+tk.W)
    row+=1
    self.dec_2_button.grid(row=row,column=0,sticky=tk.E+tk.W)
    self.inc_2_button.grid(row=row,column=1,sticky=tk.E+tk.W)
    row+=1
    self.zero_button.grid(row=row,column=0,columnspan=2,sticky=tk.E+tk.W)
    row+=1
    self.full_button.grid(row=row,column=0,columnspan=2,sticky=tk.E+tk.W)

    row+=1
    tk.Label(self,text="Output Voltage").grid(row=row,column=0)
    self.output_entry.grid(row=row,column=1, sticky=tk.E+tk.W)
    row+=1
    tk.Label(self,text="Input Voltage").grid(row=row,column=0)
    self.input_entry.grid(row=row,column=1, sticky=tk.E+tk.W)
    row+=1
    tk.Label(self,text="Ramp MIN").grid(row=row,column=0)
    self.min_entry.grid(row=row,column=1, sticky=tk.E+tk.W)
    row+=1
    tk.Label(self,text="Ramp MAX").grid(row=row,column=0)
    self.max_entry.grid(row=row,column=1, sticky=tk.E+tk.W)
    row+=1
    tk.Label(self,text="Ramp Step").grid(row=row,column=0)
    self.step_entry.grid(row=row,column=1, sticky=tk.E+tk.W)
    row+=1
    tk.Label(self,text="Ramp Delay").grid(row=row,column=0)
    self.delay_entry.grid(row=row,column=1, sticky=tk.E+tk.W)
    
    row+=1
    self.run_button.grid(row=row,column=0, sticky=tk.E+tk.W)
    self.stop_button.grid(row=row,column=1, sticky=tk.E+tk.W)

  def set_output_voltage(self, volts):
    if volts > 5.0:
      volts = 5.0
    elif volts < 0.0:
      volts = 0.0
    output_value = int(0xffff * volts / 5.0)
    print output_value
    labjack.getFeedback(u3.DAC16(Dac=0, Value = output_value))

  def record_file(self):
    if self.output_file is None:
      self.output_file = open(self.file_var.get(),"a")
      print "File opened"
    else:
      print "File already open"

  def close_file(self):
    if self.output_file is not None:
      self.output_file.close()
      self.output_file = None
      print "File closed"
    else:
      print "File not open"

  def inc_0(self):
    if self.output_voltage <= 4.995:
      self.output_voltage += 0.005
    else:
      self.output_voltage = 5.0
    self.set_output_voltage(self.output_voltage)
    self.output_var.set(str(self.output_voltage))

  def dec_0(self):
    if self.output_voltage >= 0.005:
      self.output_voltage -= 0.005
    else:
      self.output_voltage = 0.0
    self.set_output_voltage(self.output_voltage)
    self.output_var.set(str(self.output_voltage))

  def inc_1(self):
    if self.output_voltage <= 4.99:
      self.output_voltage += 0.01
    else:
      self.output_voltage = 5.0
    self.set_output_voltage(self.output_voltage)
    self.output_var.set(str(self.output_voltage))

  def dec_1(self):
    if self.output_voltage >= 0.01:
      self.output_voltage -= 0.01
    else:
      self.output_voltage = 0.0
    self.set_output_voltage(self.output_voltage)
    self.output_var.set(str(self.output_voltage))

  def inc_2(self):
    if self.output_voltage <= 4.9:
      self.output_voltage += 0.1
    else:
      self.output_voltage = 5.0
    self.set_output_voltage(self.output_voltage)
    self.output_var.set(str(self.output_voltage))

  def dec_2(self):
    if self.output_voltage >= 0.1:
      self.output_voltage -= 0.1
    else:
      self.output_voltage = 0.0
    self.set_output_voltage(self.output_voltage)
    self.output_var.set(str(self.output_voltage))

  def zero_output(self):
    self.output_voltage = 0.0
    self.set_output_voltage(self.output_voltage)
    self.output_var.set(str(self.output_voltage))

  def max_output(self):
    self.output_voltage = 5.0
    self.set_output_voltage(self.output_voltage)
    self.output_var.set(str(self.output_voltage))

  def run_ramp(self):
    self.ramp_enable = False

    try:
      self.min_voltage = float(self.min_var.get())
    except ValueError:
      print "Invalid min voltage"
      return

    try:
      self.max_voltage = float(self.max_var.get())
    except ValueError:
      print "Invalid max voltage"
      return

    try:
      self.step_voltage = float(self.step_var.get())
      if self.step_voltage == 0.0:
        raise ValueError()
    except ValueError:
      print "Invalid step voltage"
      return

    try:
      self.delay_time = float(self.delay_var.get())
      if self.delay_time <= 0.1:
        self.delay_time = 0.1
    except:
      print "Invalid delay value"
      return

    if self.step_voltage < 0:
      self.output_voltage = self.max_voltage
    else:
      self.output_voltage = self.min_voltage

    self.set_output_voltage(self.output_voltage)
    self.output_var.set(str(self.output_voltage))

    self.after_cancel(self.ramp_timer_id)
    self.ramp_timer_id = self.after(int(self.delay_time*1000),self.ramp_timer_tick)

    self.ramp_enable = True

  def stop_ramp(self):
    self.ramp_enable = False

  def ramp_timer_tick(self):
    if self.ramp_enable:
      self.output_voltage += self.step_voltage
      self.set_output_voltage(self.output_voltage)
      self.output_var.set(str(self.output_voltage))

      if self.output_voltage <= self.min_voltage or self.output_voltage >= self.max_voltage:
        self.ramp_enable = False

    self.ramp_timer_id = self.after(int(self.delay_time*1000),self.ramp_timer_tick)

  def csv_timer_tick(self):
    self.input_voltage = labjack.readRegister(REG_AIN0)
    self.input_var.set(str(self.input_voltage))

    if self.output_file is not None:
      self.output_file.write("%f, %f, %f\n" % (time.time(), self.output_voltage, self.input_voltage))
    self.csv_timer_id = self.after(100,self.csv_timer_tick)


if __name__ == "__main__":
  labjack = u3.U3()
  labjack.configU3(FIOAnalog = 0xff)

  print labjack.configU3()
  print labjack.configAnalog()

  app = CrusherApp()
  app.mainloop()

  



